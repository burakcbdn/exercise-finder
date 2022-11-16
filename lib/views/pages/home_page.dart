import 'package:exercises_assistant_app/controllers/api_controller.dart';
import 'package:exercises_assistant_app/controllers/globals.dart';
import 'package:exercises_assistant_app/models/exercise.model.dart';
import 'package:exercises_assistant_app/views/widgets/exercise_widget.dart';
import 'package:exercises_assistant_app/views/widgets/filter_category.dart';
import 'package:exercises_assistant_app/views/widgets/filter_options.dart';
import 'package:exercises_assistant_app/views/widgets/info_box.dart';
import 'package:exercises_assistant_app/views/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchExercises();

    // listen to scroll events for pagination
    scrollController.addListener(() {
      // check if user has scrolled to the bottom of the page
      double maxScroll = scrollController.position.maxScrollExtent;
      double height = MediaQuery.of(context).size.height;

      double currentScroll = scrollController.position.pixels;
      double delta = height * 0.20;

      if (maxScroll - currentScroll <= delta) {
        fetchExercises();
      }
    });
  }

  List<ExerciseModel> exercises = [];

  // pagination parameters
  bool loading = false;
  bool hasMore = true;
  bool error = false;
  int offset = 0;

  // show loading indicator on center at first load
  bool initialLoading = true;

  // fetch exercises from API according to the filters and the query
  Future fetchExercises() async {
    // if there are no more exercises to fetch, return
    if (!hasMore) {
      return;
    }

    // if there is already a request in progress, return
    if (loading) {
      return;
    }

    // set loading to true
    setState(() {
      loading = true;
    });

    try {
      // fetch exercises from API
      var res = await APIController.getExercises(
        offset: offset,
        query: activeQueryString,
        muscle: selectedMuscle,
        type: selectedType,
      );

      // if there are no more exercises to fetch, set hasMore to false
      if (res.isEmpty) {
        setState(() {
          hasMore = false;
          loading = false;
        });
        return;
      }

      // add fetched exercises to the list
      setState(() {
        loading = false;
        initialLoading = false;
        exercises.addAll(res);
        offset += 10; // increase offset for pagination
      });
    } catch (e) {
      // if there is an error, set error to true
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  InputBorder createBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(35),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    );
  }

  // Filter page controller
  PageController filterPageController = PageController();
  int currentFilterIndex = 0;

  // Filter parameters
  String selectedMuscle = '';
  String selectedType = '';
  String activeQueryString = '';

  TextEditingController searchController = TextEditingController();

  // Focus node for search field for showing or hiding the keyboard
  FocusNode searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onEndDrawerChanged: (_) {
        // if the filter drawer is closed, reset the filter page controller
        setState(() {
          currentFilterIndex = 0;
        });
      },
      endDrawer: Builder(builder: (context) {
        // create temp variables on filter drawer is opened
        String tempSelectedMuscles = selectedMuscle;
        String tempSelectedTypes = selectedType;
        String tempActiveQueryString = activeQueryString;

        return StatefulBuilder(builder: (context, setFilter) {
          return Drawer(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        if (currentFilterIndex == 0) {
                          // if the current page is the first page, close the drawer
                          Navigator.of(context).pop();
                        } else {
                          // if the current page is not the first page, go to the filter page
                          setFilter(() {
                            currentFilterIndex = 0;
                          });
                          filterPageController.jumpToPage(0);
                        }
                      },
                      child: Icon(
                        currentFilterIndex == 0 ? Icons.close : Icons.chevron_left, // display icon according to the page
                        size: currentFilterIndex != 0 ? 30 : null,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        // reset the filters according to the page, clear all if first page
                        switch (currentFilterIndex) {
                          case 0:
                            setFilter(() {
                              tempSelectedMuscles = '';
                              tempSelectedTypes = '';
                            });
                            break;
                          case 1:
                            setFilter(() {
                              tempSelectedMuscles = '';
                            });
                            break;
                          case 2:
                            setFilter(() {
                              tempSelectedTypes = '';
                            });
                            break;
                          default:
                        }
                      },
                      child: Text(
                        currentFilterIndex == 0 ? 'Clear All' : 'Clear',
                      ),
                    ),
                    title: Text(
                      Globals.filterIndexData[currentFilterIndex]!, // display title according to the page
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Filter categories and filter options
                  Flexible(
                    child: PageView(
                      onPageChanged: (n) {
                        setFilter(() {
                          currentFilterIndex = n;
                        });
                      },
                      controller: filterPageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            // show query filter if the query is not empty
                            if (tempActiveQueryString.isNotEmpty)
                              ListTile(
                                onTap: () {
                                  // clear the query and fetch again
                                  activeQueryString = '';
                                  tempActiveQueryString = '';
                                  searchController.text = '';
                                  setFilter(() {});
                                  setState(() {
                                    hasMore = true;
                                    offset = 0;
                                    exercises.clear();
                                  });
                                  Navigator.pop(context);
                                  fetchExercises();
                                },
                                title: Text(
                                  'Query',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                subtitle: tempActiveQueryString != '' ? Text(tempActiveQueryString) : null,
                                trailing: const Text(
                                  'Clear',
                                  style: TextStyle(
                                    color: Colors.purple,
                                  ),
                                ),
                              ),

                            FilterCategory(
                              filterPageController: filterPageController,
                              index: 1,
                              selection: tempSelectedMuscles,
                            ),
                            FilterCategory(
                              filterPageController: filterPageController,
                              index: 2,
                              selection: tempSelectedTypes,
                            ),

                            // apply selected filters and fetch results again
                            CupertinoButton(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Apply Filters',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  // clear pagination data
                                  selectedMuscle = tempSelectedMuscles;
                                  selectedType = tempSelectedTypes;
                                  exercises.clear();
                                  offset = 0;
                                  hasMore = true;
                                });

                                fetchExercises();

                                Navigator.pop(context, true);
                              },
                            ),
                          ],
                        ),
                        FilterOptions(
                          data: Globals.muscleData,
                          selection: tempSelectedMuscles,
                          onTap: (s) {
                            setFilter(() {
                              tempSelectedMuscles = s;
                            });
                          },
                        ),
                        FilterOptions(
                          data: Globals.typeData,
                          selection: tempSelectedTypes,
                          onTap: (s) {
                            setFilter(() {
                              tempSelectedTypes = s;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.purple,
            toolbarHeight: 70,
            floating: true,
            // putting sized box for actions to hide default drawer menu icon
            actions: const [
              SizedBox(),
            ],
            title: StatefulBuilder(builder: (context, setSearch) {
              bool searching = searchController.text.isNotEmpty;

              return Row(
                children: [
                  // search filter
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      onChanged: (s) {
                        setSearch(() {});
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.white,
                        border: createBorder(),
                        enabledBorder: createBorder(),
                        focusedBorder: createBorder(),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),

                  // if the search field is not empty, show search button
                  // otheriwse show filter button
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          if (searching) {
                            setState(() {
                              // clear pagination data
                              hasMore = true;
                              exercises.clear();
                              activeQueryString = searchController.text;
                              offset = 0;
                            });

                            fetchExercises();
                            searchController.clear();
                            searchFocusNode.unfocus();
                          } else {
                            // show filter drawer
                            Scaffold.of(context).openEndDrawer();
                          }
                        },
                        icon: Icon(searching ? Icons.search : Icons.tune),
                      );
                    },
                  ),
                ],
              );
            }),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          // show info box if there is any error
          if (error)
            const SliverToBoxAdapter(
              child: InfoBox(icon: Icons.warning_amber_rounded, text: 'An error occurred'),
            ),
          // show info box if there is no result and not loading
          if (!loading)
            if (exercises.isEmpty)
              const SliverToBoxAdapter(
                child: InfoBox(icon: Icons.sentiment_dissatisfied_rounded, text: 'No exercise found'),
              ),
          // show loading indicator on center at initial loading
          if (initialLoading)
            if (exercises.isEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: const LoadingIndicator(),
                ),
              ),
          // display exercises
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // display loading indicator at the end of the list if there is more data
                  if (index == exercises.length) {
                    if (!initialLoading && loading) {
                      return const LoadingIndicator();
                    }

                    return const SizedBox();
                  }
    
                  ExerciseModel currentExercise = exercises[index];
                  return ExerciseWidget(currentExercise: currentExercise);
                },
                childCount: exercises.length + 1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
