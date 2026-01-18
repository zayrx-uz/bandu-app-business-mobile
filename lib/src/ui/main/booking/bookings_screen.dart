import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/booking/owner_booking_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/booking/booking_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: AppColor.black,
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
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: _bookings.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _bookings.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: AppColor.black,
                            ),
                          ),
                        );
                      }

                      return BookingItemWidget(
                        data: _bookings[index],
                        showStatus: true,
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
