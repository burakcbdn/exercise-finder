
// Class for holding global variables like type data and muscle data
// and their respective names
class Globals {
  
  static init() {
    typeData.forEach((key, value) {
      completeData[key] = value;
    });
    muscleData.forEach((key, value) {
      completeData[key] = value;
    });
  }

  static Map<String, String> typeData = {
    "cardio": "Cardio",
    "olympic_weightlifting": "Olympic Weightlifting",
    "plyometrics": "Plyometrics",
    "powerlifting": "Powerlifting",
    "strength": "Strength",
    "stretching": "Stretching",
    "strongman": "Strongman"
  };

  static Map<String, String> muscleData = {
    "abdominals": "Abdominals",
    "abductors": "Abductors",
    "adductors": "Adductors",
    "biceps": "Biceps",
    "calves": "Calves",
    "chest": "Chest",
    "forearms": "Forearms",
    "glutes": "Glutes",
    "hamstrings": "Hamstrings",
    "lats": "Lats",
    "lower_back":"Lowerback",
    "middle_back":  "Middleback",
    "neck": "Neck",
    "quadriceps": "Quadriceps",
    "traps": "Traps",
    "triceps": "Triceps",
    "shoulders": "Shoulders",
  };

  static Map<String, String> completeData = {};

  static Map<int, String> filterIndexData = {
    0: 'Filters',
    1: 'Muscles',
    2: 'Types',
  };
}
