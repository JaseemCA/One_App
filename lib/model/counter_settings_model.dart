import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/countersetting_entity.dart';

class CounterSettingsModel extends Equatable {
  final String title;
  final int? uid;
  final dynamic transferServices;

  ///general options.
  final dynamic language;
  final int alertTime;
  final bool alertTransfer;
  final bool requireTransfer;
  final bool notificationSound;
  final bool showPriority;
  final bool recallUnholdToken;
  final bool notification; //desktop notification in entity

  ///side menu options,navigation tabs options
  final bool hideNextToCall;
  final bool hideCancelBtnInNextToCall;
  final bool hideHoldBtnInNextToCall;
  final bool hideTodayAppointments;
  final bool hideCancelBtnInTodayAppointments;
  final bool hideCalled;
  final bool hideServedInCalled;
  final bool hideServedAndTransferredInCalled;
  final bool hideHoldedTokens;
  final bool hideHoldedQueue;
  final bool hideCancelled;
  final bool hideCancelledAppointments;
  final bool hideSideMenu;

  ///button options
  final bool alwaysDisableServeBtn;
  final bool alwaysDisableRecallBtn;
  final bool alwaysDisableNoShowBtn;
  final bool alwaysDisableCallNextBtn;
  final bool alwaysDisableHoldBtn;
  final bool neverShowServiceHoldBtn;

  //grid view options
  final bool enableGridView;
  final bool showNotTransferredInNoShow;
  final bool showHoldedInNoShow;
  final bool autoGridViewAfterServe;
  final bool autoGridViewAfterTransfer;
  final bool autoGridViewAfterNoShow;
  final bool autoGridViewAfterHold;

  /// miscellaneous options
  final bool multipleTransferAtATime;
  final bool canAddTab;
  final bool canRemoveTab;
  final bool hideSettingsBtn;
  final bool hideServiceEditBtn;
  final bool showRemarksNotification;
  final bool alwaysOnTop;
  final bool showTokensButton;
  final bool wakeLockEnabled;
  final bool enableFullScreen;
  final bool multipleTransfer;

  const CounterSettingsModel({
    required this.language,
    required this.title,
    required this.uid,
    required this.transferServices,
    required this.alertTime,
    required this.alertTransfer,
    required this.requireTransfer,
    required this.notificationSound,
    required this.showPriority,
    required this.recallUnholdToken,
    required this.notification,
    required this.hideNextToCall,
    required this.hideCancelBtnInNextToCall,
    required this.hideHoldBtnInNextToCall,
    required this.hideTodayAppointments,
    required this.hideCancelBtnInTodayAppointments,
    required this.hideCalled,
    required this.hideServedInCalled,
    required this.hideServedAndTransferredInCalled,
    required this.hideHoldedTokens,
    required this.hideHoldedQueue,
    required this.hideCancelled,
    required this.hideCancelledAppointments,
    required this.hideSideMenu,
    required this.alwaysDisableServeBtn,
    required this.alwaysDisableRecallBtn,
    required this.alwaysDisableNoShowBtn,
    required this.alwaysDisableCallNextBtn,
    required this.alwaysDisableHoldBtn,
    required this.neverShowServiceHoldBtn,
    required this.enableGridView,
    required this.showNotTransferredInNoShow,
    required this.showHoldedInNoShow,
    required this.autoGridViewAfterServe,
    required this.autoGridViewAfterTransfer,
    required this.autoGridViewAfterNoShow,
    required this.autoGridViewAfterHold,
    required this.multipleTransferAtATime,
    required this.canAddTab,
    required this.canRemoveTab,
    required this.hideSettingsBtn,
    required this.hideServiceEditBtn,
    required this.showRemarksNotification,
    required this.alwaysOnTop,
    required this.showTokensButton,
    required this.wakeLockEnabled,
    required this.enableFullScreen,
    required this.multipleTransfer,
  });

  static CounterSettingsModel fromEntity(CounterSettingsEntity entity) {
    return CounterSettingsModel(
      language: entity.language,
      title: entity.title,
      uid: entity.uid,
      transferServices: entity.transferServices,
      alertTime: entity.alertTime,
      alertTransfer: entity.alertTransfer,
      requireTransfer: entity.requireTransfer,
      notificationSound: entity.notificationSound,
      showPriority: entity.showPriority,
      recallUnholdToken: entity.recallUnholdToken,
      notification: entity.desktopNotification,
      hideNextToCall: entity.hideNextToCall,
      hideCancelBtnInNextToCall: entity.hideCancelBtnInNextToCall,
      hideHoldBtnInNextToCall: entity.hideHoldBtnInNextToCall,
      hideTodayAppointments: entity.hideTodayAppointments,
      hideCancelBtnInTodayAppointments: entity.hideCancelBtnInTodayAppointments,
      hideCalled: entity.hideCalled,
      hideServedInCalled: entity.hideServedInCalled,
      hideServedAndTransferredInCalled: entity.hideServedAndTransferredInCalled,
      hideHoldedTokens: entity.hideHoldedTokens,
      hideHoldedQueue: entity.hideHoldedQueue,
      hideCancelled: entity.hideCancelled,
      hideCancelledAppointments: entity.hideCancelledAppointments,
      hideSideMenu: entity.hideSideMenu,
      alwaysDisableServeBtn: entity.alwaysDisableServeBtn,
      alwaysDisableRecallBtn: entity.alwaysDisableRecallBtn,
      alwaysDisableNoShowBtn: entity.alwaysDisableNoShowBtn,
      alwaysDisableCallNextBtn: entity.alwaysDisableCallNextBtn,
      alwaysDisableHoldBtn: entity.alwaysDisableHoldBtn,
      neverShowServiceHoldBtn: entity.neverShowServiceHoldBtn,
      enableGridView: entity.enableGridView,
      showNotTransferredInNoShow: entity.showNotTransferredInNoShow,
      showHoldedInNoShow: entity.showHoldedInNoShow,
      autoGridViewAfterServe: entity.autoGridViewAfterServe,
      autoGridViewAfterTransfer: entity.autoGridViewAfterTransfer,
      autoGridViewAfterNoShow: entity.autoGridViewAfterNoShow,
      autoGridViewAfterHold: entity.autoGridViewAfterHold,
      multipleTransferAtATime: entity.multipleTransferAtATime,
      canAddTab: entity.canAddTab,
      canRemoveTab: entity.canRemoveTab,
      hideSettingsBtn: entity.hideSettingsBtn,
      hideServiceEditBtn: entity.hideServiceEditBtn,
      showRemarksNotification: entity.showRemarksNotification,
      alwaysOnTop: entity.alwaysOnTop,
      showTokensButton: entity.showTokensButton,
      wakeLockEnabled: true,
      enableFullScreen: false,
      multipleTransfer: entity.multipleTransfer,
    );
  }

  static CounterSettingsModel fromJson(Map<String, dynamic> json) {
    return CounterSettingsModel(
      language: json['language'],
      title: json['title'],
      uid: json['uid'],
      transferServices: json['transferServices'],
      alertTime: json['alertTime'] is String
          ? int.parse(json['alertTime'])
          : json['alertTime'],
      alertTransfer: json['alertTransfer'],
      requireTransfer: json['requireTransfer'],
      notificationSound: json['notificationSound'],
      showPriority: json['showPriority'],
      recallUnholdToken: json['recallUnholdToken'],
      notification: json['notification'],
      hideNextToCall: json['hideNextToCall'],
      hideCancelBtnInNextToCall: json['hideCancelBtnInNextToCall'] ?? false,
      hideHoldBtnInNextToCall: json['hideHoldBtnInNextToCall'] ?? false,
      hideTodayAppointments: json['hideTodayAppointments'],
      hideCancelBtnInTodayAppointments:
          json['hideCancelBtnInTodayAppointments'] ?? false,
      hideCalled: json['hideCalled'],
      hideServedInCalled: json['hideServedInCalled'],
      hideServedAndTransferredInCalled:
          json['hideServedAndTransferredInCalled'],
      hideHoldedTokens: json['hideHoldedTokens'],
      hideHoldedQueue: json['hideHoldedQueue'],
      hideCancelled: json['hideCancelled'],
      hideCancelledAppointments: json['hideCancelledAppointments'],
      hideSideMenu: json['hideSideMenu'],
      alwaysDisableServeBtn: json['alwaysDisableServeBtn'],
      alwaysDisableRecallBtn: json['alwaysDisableRecallBtn'],
      alwaysDisableNoShowBtn: json['alwaysDisableNoShowBtn'],
      alwaysDisableCallNextBtn: json['alwaysDisableCallNextBtn'],
      alwaysDisableHoldBtn: json['alwaysDisableHoldBtn'],
      neverShowServiceHoldBtn: json['neverShowServiceHoldBtn'],
      enableGridView: json['enableGridView'],
      showNotTransferredInNoShow: json['showNotTransferredInNoShow'],
      showHoldedInNoShow: json['showHoldedInNoShow'] ?? false,
      autoGridViewAfterServe: json['autoGridViewAfterServe'],
      autoGridViewAfterTransfer: json['autoGridViewAfterTransfer'],
      autoGridViewAfterNoShow: json['autoGridViewAfterNoShow'],
      autoGridViewAfterHold: json['autoGridViewAfterHold'],
      multipleTransferAtATime: json['multipleTransferAtATime'],
      canAddTab: json['canAddTab'] ?? true,
      canRemoveTab: json['canRemoveTab'] ?? true,
      hideSettingsBtn: json['hideSettingsBtn'] ?? false,
      hideServiceEditBtn: json['hideServiceEditBtn'] ?? false,
      showRemarksNotification: json['showRemarksNotification'] ?? false,
      alwaysOnTop: json['alwaysOnTop'],
      showTokensButton: json['showTokensButton'],
      wakeLockEnabled: json['wakeLockEnabled'],
      enableFullScreen: json['enableFullScreen'],
      multipleTransfer: json['multipleTransfer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'title': title,
      'uid': uid,
      'transferServices': transferServices,
      'alertTime': alertTime,
      'alertTransfer': alertTransfer,
      'requireTransfer': requireTransfer,
      'notificationSound': notificationSound,
      'showPriority': showPriority,
      'recallUnholdToken': recallUnholdToken,
      'notification': notification,
      'hideNextToCall': hideNextToCall,
      'hideCancelBtnInNextToCall': hideCancelBtnInNextToCall,
      'hideHoldBtnInNextToCall': hideHoldBtnInNextToCall,
      'hideTodayAppointments': hideTodayAppointments,
      'hideCancelBtnInTodayAppointments': hideCancelBtnInTodayAppointments,
      'hideCalled': hideCalled,
      'hideServedInCalled': hideServedInCalled,
      'hideServedAndTransferredInCalled': hideServedAndTransferredInCalled,
      'hideHoldedTokens': hideHoldedTokens,
      'hideHoldedQueue': hideHoldedQueue,
      'hideCancelled': hideCancelled,
      'hideCancelledAppointments': hideCancelledAppointments,
      'hideSideMenu': hideSideMenu,
      'alwaysDisableServeBtn': alwaysDisableServeBtn,
      'alwaysDisableRecallBtn': alwaysDisableRecallBtn,
      'alwaysDisableNoShowBtn': alwaysDisableNoShowBtn,
      'alwaysDisableCallNextBtn': alwaysDisableCallNextBtn,
      'alwaysDisableHoldBtn': alwaysDisableHoldBtn,
      'neverShowServiceHoldBtn': neverShowServiceHoldBtn,
      'enableGridView': enableGridView,
      'showNotTransferredInNoShow': showNotTransferredInNoShow,
      'showHoldedInNoShow': showHoldedInNoShow,
      'autoGridViewAfterServe': autoGridViewAfterServe,
      'autoGridViewAfterTransfer': autoGridViewAfterTransfer,
      'autoGridViewAfterNoShow': autoGridViewAfterNoShow,
      'autoGridViewAfterHold': autoGridViewAfterHold,
      'multipleTransferAtATime': multipleTransferAtATime,
      'canAddTab': canAddTab,
      'canRemoveTab': canRemoveTab,
      'hideSettingsBtn': hideSettingsBtn,
      'hideServiceEditBtn': hideServiceEditBtn,
      'showRemarksNotification': showRemarksNotification,
      'alwaysOnTop': alwaysOnTop,
      'showTokensButton': showTokensButton,
      'wakeLockEnabled': wakeLockEnabled,
      'enableFullScreen': enableFullScreen,
      'multipleTransfer': multipleTransfer,
    };
  }

  Map<String, dynamic> toJsonEntity() {
    return {
      'language': language,
      'title': title,
      'uid': uid,
      'transfer_services': transferServices,
      'alert_time': alertTime,
      'alert_transfer': alertTransfer,
      'require_transfer': requireTransfer,
      'notification_sound': notificationSound,
      'show_priority': showPriority,
      'recall_unhold_token': recallUnholdToken,
      'notification': notification,
      'hide_nexto_call': hideNextToCall,
      'hide_cancel_btn_in_next_to_call': hideCancelBtnInNextToCall,
      'hide_hold_btn_in_next_to_call': hideHoldBtnInNextToCall,
      'hide_today_appointments': hideTodayAppointments,
      'hide_cancel_btn_in_today_appointments': hideCancelBtnInTodayAppointments,
      'hide_called': hideCalled,
      'hide_served_in_called': hideServedInCalled,
      'hide_served_and_transferred_in_called': hideServedAndTransferredInCalled,
      'hide_holded_tokens': hideHoldedTokens,
      'hide_holded_queue': hideHoldedQueue,
      'hide_cancelled': hideCancelled,
      'hide_cancelled_appointments': hideCancelledAppointments,
      'hide_side_menu': hideSideMenu,
      'always_disable_serve_btn': alwaysDisableServeBtn,
      'always_disable_recall_btn': alwaysDisableRecallBtn,
      'always_disable_noShow_btn': alwaysDisableNoShowBtn,
      'always_disable_callNext_btn': alwaysDisableCallNextBtn,
      'always_disable_hold_btn': alwaysDisableHoldBtn,
      'never_show_service_hold_btn': neverShowServiceHoldBtn,
      'enable_grid_view': enableGridView,
      'show_not_transferred_in_no_show': showNotTransferredInNoShow,
      'auto_grid_view_after_serve': autoGridViewAfterServe,
      'auto_grid_view_after_transfer': autoGridViewAfterTransfer,
      'auto_grid_view_after_no_show': autoGridViewAfterNoShow,
      'auto_grid_view_after_hold': autoGridViewAfterHold,
      'multiple_transfer_at_a_Time': multipleTransferAtATime,
      'can_add_tab': canAddTab,
      'can_remove_tab': canRemoveTab,
      'hide_settings_btn': hideSettingsBtn,
      'hide_service_edit_btn': hideServiceEditBtn,
      'show_remarks_notification': showRemarksNotification,
      'always_on_top': alwaysOnTop,
      'show_tokens_button': showTokensButton,
      'wake_lock_enabled': wakeLockEnabled,
      'enable_full_screen': enableFullScreen,
      'multiple_transfer': multipleTransfer,
    };
  }

  static CounterSettingsModel generateDefaultSettings() {
    return const CounterSettingsModel(
      language: null,
      title: '',
      uid: 0,
      transferServices: [],
      alertTime: 10,
      alertTransfer: false,
      requireTransfer: false,
      notificationSound: false,
      showPriority: false,
      recallUnholdToken: true,
      notification: false,
      hideNextToCall: false,
      hideCancelBtnInNextToCall: false,
      hideHoldBtnInNextToCall: false,
      hideTodayAppointments: false,
      hideCancelBtnInTodayAppointments: false,
      hideCalled: false,
      hideServedInCalled: false,
      hideServedAndTransferredInCalled: false,
      hideHoldedTokens: false,
      hideHoldedQueue: false,
      hideCancelled: false,
      hideCancelledAppointments: false,
      hideSideMenu: false,
      alwaysDisableServeBtn: false,
      alwaysDisableRecallBtn: false,
      alwaysDisableNoShowBtn: false,
      alwaysDisableCallNextBtn: false,
      alwaysDisableHoldBtn: false,
      neverShowServiceHoldBtn: false,
      enableGridView: false,
      showNotTransferredInNoShow: false,
      showHoldedInNoShow: false,
      autoGridViewAfterServe: false,
      autoGridViewAfterTransfer: false,
      autoGridViewAfterNoShow: false,
      autoGridViewAfterHold: false,
      multipleTransferAtATime: false,
      canAddTab: true,
      canRemoveTab: true,
      hideSettingsBtn: false,
      hideServiceEditBtn: false,
      showRemarksNotification: false,
      alwaysOnTop: false,
      showTokensButton: false,
      wakeLockEnabled: true,
      enableFullScreen: false,
      multipleTransfer: false,
    );
  }

  @override
  List<Object?> get props => [
        language,
        title,
        uid,
        transferServices,
        alertTime,
        alertTransfer,
        requireTransfer,
        notificationSound,
        showPriority,
        recallUnholdToken,
        notification,
        hideNextToCall,
        hideCancelBtnInNextToCall,
        hideHoldBtnInNextToCall,
        hideTodayAppointments,
        hideCancelBtnInTodayAppointments,
        hideCalled,
        hideServedInCalled,
        hideServedAndTransferredInCalled,
        hideHoldedTokens,
        hideHoldedQueue,
        hideCancelled,
        hideCancelledAppointments,
        hideSideMenu,
        alwaysDisableServeBtn,
        alwaysDisableRecallBtn,
        alwaysDisableNoShowBtn,
        alwaysDisableCallNextBtn,
        alwaysDisableHoldBtn,
        neverShowServiceHoldBtn,
        enableGridView,
        showNotTransferredInNoShow,
        showHoldedInNoShow,
        autoGridViewAfterServe,
        autoGridViewAfterTransfer,
        autoGridViewAfterNoShow,
        autoGridViewAfterHold,
        multipleTransferAtATime,
        canAddTab,
        canRemoveTab,
        hideSettingsBtn,
        hideServiceEditBtn,
        showRemarksNotification,
        alwaysOnTop,
        showTokensButton,
        wakeLockEnabled,
        enableFullScreen,
        multipleTransfer,
      ];
}
