import 'dart:async';

class SocketService {
  static StreamController homePageRebuildRequiredController =
      StreamController<bool>.broadcast();
  static StreamController homePageAppBarRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController tokensPageRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController appointmentPageRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController settingsPageRebuildRequiredController =
      StreamController<bool>.broadcast();

  static StreamController eventReceivedController =
      StreamController<int>.broadcast();





      
}
