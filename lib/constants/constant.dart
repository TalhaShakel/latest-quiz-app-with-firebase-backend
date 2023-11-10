class Constants {

  //Don't edit these values

  //notification topic
  static const String fcmSubcriptionTopticforAll = 'all';

  //notification tag for hive local database
  static const String notificationTag = 'notifications';

  //Question Orders
  static const List<String> questionOrders = [
    'Random',
    'Oldest First',
    'Newest First',
  ];

  // Question Types
  static const Map<String, String> questionTypes = {
    "text_only": "Text Only",
    "text_with_image": "Image",
    "text_with_audio": "Audio",
    "text_with_video": "Video",
  };

  
  //Option Types
  static const Map<String, String> optionTypes = {
    "text_only": "Text Only",
    "t/f": "True/False",
    "image": "Images"
  };
}