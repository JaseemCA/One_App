import 'package:equatable/equatable.dart';

class CounterSettingsEntity extends Equatable {
  final String title;
  final int? uid;
  final int alertTime;
  final dynamic transferServices;
  final bool alertTransfer;
  final bool requireTransfer;
  final bool showTokensButton;
  final bool notificationSound;
  final bool showPriority;
  final bool recallUnholdToken;
  final bool multipleTransfer;
  final bool multipleTransferAtATime;
  final bool alwaysOnTop;
  final bool desktopNotification;
  final bool hideSideMenu;
  final bool hideNextToCall;
  final bool hideTodayAppointments;
  final bool hideCalled;
  final bool hideServedInCalled;
  final bool hideServedAndTransferredInCalled;
  final bool hideHoldedTokens;
  final bool hideHoldedQueue;
  final bool hideCancelled;
  final bool hideCancelledAppointments;
  final bool alwaysDisableServeBtn;
  final bool alwaysDisableRecallBtn;
  final bool alwaysDisableNoShowBtn;
  final bool alwaysDisableCallNextBtn;
  final bool alwaysDisableHoldBtn;
  final bool neverShowServiceHoldBtn;
  final bool enableGridView;
  final bool showNotTransferredInNoShow;
  final bool showHoldedInNoShow;
  final bool autoGridViewAfterServe;
  final bool autoGridViewAfterTransfer;
  final bool autoGridViewAfterNoShow;
  final bool autoGridViewAfterHold;
  final dynamic language;

  const CounterSettingsEntity(
    this.title,
    this.uid,
    this.alertTime,
    this.transferServices,
    this.alertTransfer,
    this.requireTransfer,
    this.showTokensButton,
    this.notificationSound,
    this.showPriority,
    this.recallUnholdToken,
    this.multipleTransfer,
    this.multipleTransferAtATime,
    this.alwaysOnTop,
    this.desktopNotification,
    this.hideSideMenu,
    this.hideNextToCall,
    this.hideTodayAppointments,
    this.hideCalled,
    this.hideServedInCalled,
    this.hideServedAndTransferredInCalled,
    this.hideHoldedTokens,
    this.hideHoldedQueue,
    this.hideCancelled,
    this.hideCancelledAppointments,
    this.alwaysDisableServeBtn,
    this.alwaysDisableRecallBtn,
    this.alwaysDisableNoShowBtn,
    this.alwaysDisableCallNextBtn,
    this.alwaysDisableHoldBtn,
    this.neverShowServiceHoldBtn,
    this.enableGridView,
    this.showNotTransferredInNoShow,
    this.showHoldedInNoShow,
    this.autoGridViewAfterServe,
    this.autoGridViewAfterTransfer,
    this.autoGridViewAfterNoShow,
    this.autoGridViewAfterHold,
    this.language,
  );

  static CounterSettingsEntity fromJson(Map<String, dynamic> json) {
    return CounterSettingsEntity(
        json['title'],
        json['uid'],
        json['alert_time'],
        json['transfer_services'],
        json['alert_transfer'],
        json['require_transfer'],
        json['show_tokens_button'],
        json['notification_sound'],
        json['show_priority'],
        json['recall_unhold_token'],
        json['multiple_transfer'],
        json['multiple_transfer_at_a_time'],
        json['always_on_top'],
        json['desktop_notification'],
        json['hide_side_menu'],
        json['hide_next_to_call'],
        json['hide_today_appointments'],
        json['hide_called'],
        json['hide_served_in_called'],
        json['hide_served_and_transferred_in_called'],
        json['hide_holded_tokens'],
        json['hide_holded_queue'],
        json['hide_cancelled'],
        json['hide_cancelled_appointments'],
        json['always_disable_serve_btn'],
        json['always_disable_recall_btn'],
        json['always_disable_no_show_btn'],
        json['always_disable_call_next_btn'],
        json['always_disable_hold_btn'],
        json['never_show_service_hold_btn'],
        json['enable_grid_view'],
        json['show_not_transferred_in_no_show'],
        // ignore: prefer_if_null_operators
        json['show_holded_in_no_show'] != null
            ? json['show_holded_in_no_show']
            : false,
        json['auto_grid_view_after_serve'],
        json['auto_grid_view_after_transfer'],
        json['auto_grid_view_after_no_show'],
        json['auto_grid_view_after_hold'],
        json['language']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'uid': uid,
      'alert_time': alertTime,
      'transfer_services': transferServices,
      'alert_transfer': alertTransfer,
      'require_transfer': requireTransfer,
      'show_tokens_button': showTokensButton,
      'notification_sound': notificationSound,
      'show_priority': showPriority,
      'recall_unhold_token': recallUnholdToken,
      'multiple_transfer': multipleTransfer,
      'multiple_transfer_at_a_time': multipleTransferAtATime,
      'always_on_top': alwaysOnTop, //pinned in android if this option is true
      'desktop_notification':
          desktopNotification, //notification shown if this value is true
      'hide_side_menu': hideSideMenu,
      'hide_next_to_call': hideNextToCall,
      'hide_today_appointments': hideTodayAppointments,
      'hide_called': hideCalled,
      'hide_served_in_called': hideServedInCalled,
      'hide_served_and_transferred_in_called': hideServedAndTransferredInCalled,
      'hide_holded_tokens': hideHoldedTokens,
      'hide_holded_queue': hideHoldedQueue,
      'hide_cancelled': hideCancelled,
      'hide_cancelled_appointments': hideCancelledAppointments,
      'always_disable_serve_btn': alwaysDisableServeBtn,
      'always_disable_recall_btn': alwaysDisableRecallBtn,
      'always_disable_no_show_btn': alwaysDisableNoShowBtn,
      'always_disable_call_next_btn': alwaysDisableCallNextBtn,
      'always_disable_hold_btn': alwaysDisableHoldBtn,
      'never_show_service_hold_btn': neverShowServiceHoldBtn,
      'enable_grid_view': enableGridView,
      'show_not_transferred_in_no_show': showNotTransferredInNoShow,
      'show_holded_in_no_show': showHoldedInNoShow,
      'auto_grid_view_after_serve': autoGridViewAfterServe,
      'auto_grid_view_after_transfer': autoGridViewAfterTransfer,
      'auto_grid_view_after_no_show': autoGridViewAfterNoShow,
      'auto_grid_view_after_hold': autoGridViewAfterHold,
      'language': language,
    };
  }

  @override
  List<Object?> get props => [
        title,
        uid,
        alertTime,
        transferServices,
        alertTransfer,
        requireTransfer,
        showTokensButton,
        notificationSound,
        showPriority,
        recallUnholdToken,
        multipleTransfer,
        multipleTransferAtATime,
        alwaysOnTop,
        desktopNotification,
        hideSideMenu,
        hideNextToCall,
        hideTodayAppointments,
        hideCalled,
        hideServedInCalled,
        hideServedAndTransferredInCalled,
        hideHoldedTokens,
        hideHoldedQueue,
        hideCancelled,
        hideCancelledAppointments,
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
        language
      ];
}
