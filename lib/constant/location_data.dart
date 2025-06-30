// lib/data/location_data.dart

const List<String> allStates = [
  'Odisha',
  'Maharashtra',
  'Karnataka',
  // Add more states
];

const Map<String, List<String>> stateDistrictMap = {
  'Odisha': ['Bhubaneswar', 'Cuttack', 'Puri'],
  'Maharashtra': ['Mumbai', 'Pune'],
  'Karnataka': ['Bengaluru', 'Mysuru'],
};

const Map<String, List<String>> districtCityMap = {
  'Bhubaneswar': ['Patia', 'Old Town', 'Jaydev Vihar'],
  'Cuttack': ['Link Road', 'Choudwar'],
  'Puri': ['Konark', 'Sakhigopal'],

  'Mumbai': ['Andheri', 'Borivali'],
  'Pune': ['Shivajinagar', 'Kothrud'],

  'Bengaluru': ['Whitefield', 'Indiranagar'],
  'Mysuru': ['VV Mohalla', 'Gokulam'],
};
