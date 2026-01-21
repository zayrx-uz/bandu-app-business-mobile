import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/model/api/main/notification/notification_model.dart';
import 'package:bandu_business/src/provider/main/home/home_provider.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/settings/notification/notification_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  final HomeProvider _provider = HomeProvider();
  List<NotificationItemData> _notifications = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        _hasMore &&
        !_isLoading) {
      _loadMoreNotifications();
    }
  }

  Future<void> _loadNotifications() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _notifications = [];
      _hasMore = true;
    });

    final result = await _provider.getNotifications(
      page: _currentPage,
      limit: _limit,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result.isSuccess && result.result != null) {
        try {
          final model = NotificationModel.fromJson(result.result);
          setState(() {
            _notifications = model.data;
            _hasMore = model.meta.page < model.meta.totalPages;
          });
        } catch (e) {
          setState(() {
            _notifications = [];
            _hasMore = false;
          });
        }
      } else {
        setState(() {
          _notifications = [];
          _hasMore = false;
        });
      }
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    final result = await _provider.getNotifications(
      page: _currentPage,
      limit: _limit,
    );

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });

      if (result.isSuccess && result.result != null) {
        try {
          final model = NotificationModel.fromJson(result.result);
          setState(() {
            _notifications.addAll(model.data);
            _hasMore = model.meta.page < model.meta.totalPages;
          });
        } catch (e) {
          setState(() {
            _hasMore = false;
          });
        }
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _currentPage = 1;
      _notifications = [];
      _hasMore = true;
      _isLoadingMore = false;
    });
    await _loadNotifications();
  }

  Future<void> _markAsRead(int notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;

    final notification = _notifications[index];
    if (notification.isRead) return;

    final originalNotification = NotificationItemData(
      id: notification.id,
      userId: notification.userId,
      title: notification.title,
      description: notification.description,
      type: notification.type,
      data: notification.data,
      sentAt: notification.sentAt,
      readAt: notification.readAt,
    );

    setState(() {
      _notifications[index] = NotificationItemData(
        id: notification.id,
        userId: notification.userId,
        title: notification.title,
        description: notification.description,
        type: notification.type,
        data: notification.data,
        sentAt: notification.sentAt,
        readAt: DateTime.now(),
      );
    });

    final result = await _provider.markNotificationAsRead(notificationId: notificationId);
    
    if (mounted) {
      if (!result.isSuccess) {
        setState(() {
          _notifications[index] = originalNotification;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cF4F5F4,
      // bottomNavigationBar: _notifications.isNotEmpty
      //     ? Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           AppButton(
      //             onTap: () {},
      //             text: "markAsRead".tr(),
      //             border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
      //             isGradient: false,
      //             backColor: Colors.white,
      //             txtColor: Colors.black,
      //             leftIconColor: Colors.black,
      //             leftIcon: AppIcons.ticksIcon,
      //           ),
      //           SizedBox(height: 36.h),
      //         ],
      //       )
      //     : null,
      body: Column(
        children: [
          TopBarWidget(text: "notifications".tr(), isBack: true),
          Expanded(
            child: _isLoading && _notifications.isEmpty
                ? Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: AppColor.black,
                    ),
                  )
                : _notifications.isEmpty
                    ? RefreshIndicator(
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: EmptyWidget(text: "noNotifications".tr()),
                            ),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(16.w),
                          itemCount: _notifications.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _notifications.length) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: CircularProgressIndicator.adaptive(
                                    backgroundColor: AppColor.black,
                                  ),
                                ),
                              );
                            }

                            final notification = _notifications[index];
                            final isFirst = index == 0;
                            final previousDate = index > 0
                                ? _notifications[index - 1].sentAt
                                : null;
                            final showDate = isFirst ||
                                (previousDate != null &&
                                    notification.sentAt != null &&
                                    (previousDate.year != notification.sentAt!.year ||
                                        previousDate.month != notification.sentAt!.month ||
                                        previousDate.day != notification.sentAt!.day));

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showDate && notification.sentAt != null)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: Text(
                                      notification.sentAt!.toDDMMYYY(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                NotificationItem(
                                  data: notification,
                                  onTap: notification.isRead
                                      ? null
                                      : () => _markAsRead(notification.id),
                                ),
                                if (index < _notifications.length - 1)
                                  SizedBox(height: 12.h),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
