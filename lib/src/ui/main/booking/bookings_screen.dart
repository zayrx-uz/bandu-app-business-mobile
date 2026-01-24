import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/booking/owner_booking_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/booking/booking_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helper/extension/extension.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<OwnerBookingItemData> _bookings = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
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
        _hasMore) {
      _loadMoreBookings();
    }
  }

  void _loadBookings() {
    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId > 0) {
      BlocProvider.of<HomeBloc>(context).add(
        GetOwnerBookingsEvent(
          page: 1,
          limit: _limit,
          companyId: companyId,
        ),
      );
    }
  }

  void _loadMoreBookings() {
    if (_isLoadingMore || !_hasMore) return;

    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId > 0) {
      setState(() {
        _isLoadingMore = true;
        _currentPage++;
      });

      BlocProvider.of<HomeBloc>(context).add(
        GetOwnerBookingsEvent(
          page: _currentPage,
          limit: _limit,
          companyId: companyId,
        ),
      );
    }
  }

  void _refresh() {
    setState(() {
      _currentPage = 1;
      _bookings = [];
      _hasMore = true;
      _isLoadingMore = false;
    });
    _loadBookings();
  }

  void _sortBookingsByDate() {
    _bookings.sort((a, b) {
      if (a.bookingTime == null && b.bookingTime == null) return 0;
      if (a.bookingTime == null) return 1;
      if (b.bookingTime == null) return -1;
      return a.bookingTime!.compareTo(b.bookingTime!);
    });
  }


  bool _timezoneInitialized = false;

  String _formatDateTime(DateTime? dateTime, DateTime? endTime) {
    if (dateTime == null) return "";

    _ensureTimezoneInitialized();
    final tashkent = tz.getLocation('Asia/Tashkent');

    final tashkentTime = tz.TZDateTime.from(dateTime, tashkent);
    final date = tashkentTime.toDDMMYYY();
    final startTime = tashkentTime.toString().substring(11, 16);

    if (endTime != null) {
      final tashkentEndTime = tz.TZDateTime.from(endTime, tashkent);
      final endTimeStr = tashkentEndTime.toString().substring(11, 16);
      return date;
    }

    return date;
  }

  void _ensureTimezoneInitialized() {
    if (!_timezoneInitialized) {
      try {
        tz_data.initializeTimeZones();
        _timezoneInitialized = true;
      } catch (e) {
        _timezoneInitialized = true;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          TopBarWidget(
            text: "band qilingan".tr(),
            isBack: true,
            isAppName: false,
          ),
          Expanded(
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is GetOwnerBookingsSuccessState) {
                  setState(() {
                    if (state.isLoadMore) {
                      _isLoadingMore = true;
                    } else {
                      if (state.meta.page == 1) {
                        _bookings = state.data;
                      } else {
                        _bookings.addAll(state.data);
                      }
                      _sortBookingsByDate();
                      _hasMore = state.meta.page < state.meta.totalPages;
                      _isLoadingMore = false;
                    }
                  });
                } else if (state is HomeErrorState && !_isLoadingMore) {
                  setState(() {
                    _isLoadingMore = false;
                  });
                }
              },
              builder: (context, state) {
                if (state is GetOwnerBookingsLoadingState && _bookings.isEmpty) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: AppColor.black,
                    ),
                  );
                }

                if (_bookings.isEmpty && state is! GetOwnerBookingsLoadingState) {
                  return Center(
                    child: EmptyWidget(text: "noBookings".tr()),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _refresh();
                    await Future.delayed(Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: _bookings.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _bookings.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: CupertinoActivityIndicator(
                              color: AppColor.black,
                            ),
                          ),
                        );
                      }

                      final booking = _bookings[index];
                      final isFirst = index == 0;
                      final previousBooking = index > 0 ? _bookings[index - 1] : null;
                      final previousDate = previousBooking?.bookingTime;
                      final showDate = isFirst ||
                          (previousDate != null &&
                              booking.bookingTime != null &&
                              (previousDate.year != booking.bookingTime!.year ||
                                  previousDate.month != booking.bookingTime!.month ||
                                  previousDate.day != booking.bookingTime!.day));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDate && booking.bookingTime != null)
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h, top: index > 0 ? 8.h : 0),
                              child: Text(
                                _formatDateTime(booking.bookingTime, booking.bookingEndTime),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          BookingItemWidget(
                            data: booking,
                            showStatus: true,
                          ),
                          if (index < _bookings.length - 1)
                            SizedBox(height: 12.h),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
