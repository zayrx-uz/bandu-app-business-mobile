import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/main/booking/booking_detail_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/booking/book_cancel.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class BookingDetailScreen extends StatefulWidget {
  final int bookingId;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  BookingDetailData? bookingDetail;
  bool _timezoneInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
  }

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
      return "$date ($startTime - $endTimeStr)";
    }

    return "$date ($startTime)";
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

  Color _getBookingStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColor.grey58;
      case 'confirmed':
        return AppColor.yellow8E;
      case 'canceled':
      case 'cancelled':
        return AppColor.cE52E4C;
      case 'completed':
        return AppColor.green34;
      default:
        return AppColor.grey58;
    }
  }

  Color _getBookingStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColor.greyF4;
      case 'confirmed':
        return AppColor.yellowEF;
      case 'canceled':
      case 'cancelled':
        return AppColor.redFF;
      case 'completed':
        return AppColor.green34.withValues(alpha: 0.1);
      default:
        return AppColor.greyF4;
    }
  }

  String _getCategoryIcon() {
    final placeIconUrl = CacheService.getPlaceIcon();
    
    if (placeIconUrl.isNotEmpty) {
      return placeIconUrl;
    }
    
    final ikpuCode = CacheService.getCategoryIkpuCode();
    
    if (ikpuCode.isEmpty) {
      return AppIcons.placeSelect;
    }
    
    return HelperFunctions.getCategoryIconByIkpuCode(ikpuCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
          if (state is GetBookingDetailSuccessState) {
            bookingDetail = state.data;
            _hasError = false;
            setState(() {});
          } else if (state is HomeErrorState) {
            if (state is! UpdateBookingStatusLoadingState && 
                state is! CancelBookingLoadingState && 
                state is! ExtendTimeLoadingState &&
                state is! ConfirmPaymentLoadingState &&
                state is! CheckAlicePaymentLoadingState) {
              _hasError = true;
              setState(() {});
            }
          } else if (state is UpdateBookingStatusSuccessState) {
            context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
          } else if (state is CancelBookingSuccessState) {
            context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
          } else if (state is ConfirmPaymentSuccessState) {
            context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
          } else if (state is CheckAlicePaymentSuccessState) {
            if (state.isPaid) {
              context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
            }
          } else if (state is ExtendTimeSuccessState) {
            context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
          }
      },
      builder: (context, state) {
        final isLoading = state is GetBookingDetailLoadingState;
        
        return Scaffold(
          backgroundColor: AppColor.white,
          body: Column(
            children: [
                TopBarWidget(
                  text: bookingDetail?.user.fullName ?? "",
                  isBack: true,
                  right: bookingDetail != null
                      ? Container(
                          margin: EdgeInsets.only(right: 16.w),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: _getBookingStatusBackgroundColor(bookingDetail!.status),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              width: 1.w,
                              color: _getBookingStatusColor(bookingDetail!.status).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            bookingDetail!.status.getLocalizedStatus(),
                            style: AppTextStyle.f500s20.copyWith(
                              fontSize: 14.sp,
                              color: _getBookingStatusColor(bookingDetail!.status),
                            ),
                          ),
                        )
                      : null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (isLoading)
                          Padding(
                            padding: EdgeInsets.all(40.h),
                            child: CupertinoActivityIndicator(
                              color: AppColor.black0D,
                            ),
                          )
                        else if (_hasError)
                          Padding(
                            padding: EdgeInsets.all(40.h),
                            child: EmptyWidget(
                              text: "noDataFound".tr(),
                            ),
                          )
                        else if (bookingDetail != null) ...[
                          SizedBox(height: 24.h),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 1.w,
                                color: AppColor.yellowFFC,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              children: [
                                if (bookingDetail!.places.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColor.yellowFFC.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          bookingDetail!.places.first is Map
                                              ? "${(bookingDetail!.places.first as Map)['name'] ?? ''}"
                                              : "",
                                          style: AppTextStyle.f400s16.copyWith(
                                            color: AppColor.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w,),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColor.grey77.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          bookingDetail!.places.first is Map
                                              ? "${(bookingDetail!.places.first as Map)['capacity'] ?? ''}"
                                              : "",
                                          style: AppTextStyle.f400s16.copyWith(
                                            color: AppColor.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                if (bookingDetail!.places.isNotEmpty) SizedBox(height: 12.h),
                                Builder(
                                  builder: (context) {
                                    final iconPath = _getCategoryIcon();
                                    
                                    if (iconPath.startsWith('http://') || iconPath.startsWith('https://')) {
                                      if (iconPath.endsWith('.svg')) {
                                        return SvgPicture.network(
                                          iconPath,
                                          height: 88.h,
                                          width: 80.h,
                                          fit: BoxFit.contain,
                                          placeholderBuilder: (context) => Container(
                                            height: 88.h,
                                            width: 80.h,
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        );
                                      } else {
                                        return Image.network(
                                          iconPath,
                                          height: 88.h,
                                          width: 80.h,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              height: 88.h,
                                              width: 80.h,
                                              child: CupertinoActivityIndicator(),
                                            );
                                          },
                                        );
                                      }
                                    } else if (iconPath.contains('assets/images/')) {
                                      return Image.asset(
                                        iconPath,
                                        height: 88.h,
                                        width: 80.h,
                                        fit: BoxFit.contain,
                                      );
                                    } else {
                                      return AppSvgAsset(
                                        iconPath,
                                        height: 88.h,
                                        width: 80.h,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              children: [
                                if(bookingDetail != null && bookingDetail!.user.fullName.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "firstName".tr(),
                                          style: AppTextStyle.f600s16.copyWith(
                                            color: AppColor.black,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 12.h,
                                                ),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(
                                                    12.r,
                                                  ),
                                                  border: Border.all(
                                                    width: 1.w,
                                                    color: AppColor.cE5E7E5,
                                                  ),
                                                ),
                                                child: Text(
                                                  bookingDetail!
                                                      .user
                                                      .fullName,
                                                  style: AppTextStyle.f500s16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 12.h),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "orderDate".tr(),
                                        style: AppTextStyle.f600s16.copyWith(
                                          color: AppColor.black,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(
                                            width: 1.w,
                                            color: AppColor.cE5E7E5,
                                          ),
                                        ),
                                        child: Text(
                                          bookingDetail!.bookingTime != null ? _formatDateTime(bookingDetail!.bookingTime, bookingDetail!.bookingEndTime).substring(0 , 10) : "",
                                          style: AppTextStyle.f500s16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "orderTime".tr(),
                                        style: AppTextStyle.f600s16.copyWith(
                                          color: AppColor.black,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(
                                            width: 1.w,
                                            color: AppColor.cE5E7E5,
                                          ),
                                        ),
                                        child: Text(
                                          _formatDateTime(bookingDetail!.bookingTime, bookingDetail!.bookingEndTime).substring(12 , 25),
                                          style: AppTextStyle.f500s16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                if(bookingDetail != null && bookingDetail!.user.authProviders.first.phoneNumber.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "phoneNumber".tr(),
                                          style: AppTextStyle.f600s16.copyWith(
                                            color: AppColor.black,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 12.h,
                                                ),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(
                                                    12.r,
                                                  ),
                                                  border: Border.all(
                                                    width: 1.w,
                                                    color: AppColor.cE5E7E5,
                                                  ),
                                                ),
                                                child: Text(
                                                  bookingDetail!
                                                      .user
                                                      .authProviders
                                                      .isNotEmpty
                                                      ? "+${bookingDetail!.user.authProviders.first.phoneNumber}"
                                                      : "",
                                                  style: AppTextStyle.f500s16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            AppIconButton(
                                              icon: AppIcons.phone,
                                              onTap: () async {
                                                final Uri launchUri = Uri(
                                                  scheme: 'tel',
                                                  path:
                                                  "+${bookingDetail!.user.authProviders.first.phoneNumber}",
                                                );

                                                if (await canLaunchUrl(launchUri)) {
                                                  await launchUrl(launchUri);
                                                } else {
                                                  // Xatolik yuz bersa
                                                  print(
                                                    'Telefon ilovasini ochib bo\'lmadi',
                                                  );

                                                }
                                              },
                                              width: 45.w,
                                              height: 45.w,
                                              borderRadius: 12.r,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                if(bookingDetail!.note.isNotEmpty)SizedBox(height: 12.h),
                                if(bookingDetail!.note.isNotEmpty)Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "comment".tr(),
                                        style: AppTextStyle.f600s16.copyWith(
                                          color: AppColor.black,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(
                                            width: 1.w,
                                            color: AppColor.cE5E7E5,
                                          ),
                                        ),
                                        child: Text(
                                         bookingDetail!.note,
                                          style: AppTextStyle.f500s16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          if (bookingDetail!.bookingItems.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "orderItems".tr(),
                                  style: AppTextStyle.f600s18,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: bookingDetail!.bookingItems.length,
                              itemBuilder: (context, index) {
                                final item = bookingDetail!.bookingItems[index];
                                final resource = item.resource;
                                String imageUrl = "";
                                if (resource.images.isNotEmpty) {
                                  final mainImage = resource.images.firstWhere(
                                    (img) => img.isMain,
                                    orElse: () => resource.images.first,
                                  );
                                  imageUrl = mainImage.url;
                                } else if (resource.metadata is Map &&
                                    resource.metadata['images'] != null) {
                                  final metadataImages = resource.metadata['images'] as List;
                                  if (metadataImages.isNotEmpty) {
                                    imageUrl = metadataImages.first['url']?.toString() ?? "";
                                  }
                                }
                                
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(width: 1.h, color: AppColor.greyE5),
                                  ),
                                  child: Row(
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: imageUrl,
                                        height: 72.h,
                                        width: 72.h,
                                        borderRadius: 12.r,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (resource.timeSlotDurationMinutes != null && resource.timeSlotDurationMinutes! > 0)
                                              Row(
                                                children: [
                                                  AppSvgAsset(AppIcons.hour, height: 16.h, width: 16.h),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    "${resource.timeSlotDurationMinutes} ${"minute".tr()}",
                                                    style: AppTextStyle.f400s14.copyWith(
                                                      color: AppColor.grey77,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (resource.timeSlotDurationMinutes != null && resource.timeSlotDurationMinutes! > 0)
                                              SizedBox(height: 4.h),
                                            Text(
                                              resource.name,
                                              style: AppTextStyle.f500s16,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "${resource.price.priceFormat()} UZS",
                                              style: AppTextStyle.f500s16,
                                            ),
                                            if (item.employee != null) ...[
                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  CustomNetworkImage(
                                                    imageUrl: item.employee!.profilePicture ?? "",
                                                    height: 24.h,
                                                    width: 24.h,
                                                    borderRadius: 100,
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item.employee!.fullName,
                                                          style: AppTextStyle.f400s14.copyWith(
                                                            color: AppColor.black09,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        if (item.employee!.role.isNotEmpty)
                                                          Text(
                                                            item.employee!.role,
                                                            style: AppTextStyle.f400s12.copyWith(
                                                              color: AppColor.grey77,
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 24.h),
                          ],
                          _buildActionButtons(context, state),
                          SizedBox(height: 24.h),
                        ],
                      ],
                    ),
                  ),
            ),
          ],
        ),
      );
      },
    );
  }

  bool _isBookingConfirmed() {
    if (bookingDetail == null) return false;
    return bookingDetail!.status.toLowerCase() == "confirmed";
  }

  bool _isBookingCancelled() {
    if (bookingDetail == null) return false;
    final status = bookingDetail!.status.toLowerCase();
    return status == "cancelled" || status == "canceled";
  }

  bool _isBookingPending() {
    if (bookingDetail == null) return false;
    return bookingDetail!.status.toLowerCase() == "pending";
  }

  bool _isBookingCompleted() {
    if (bookingDetail == null) return false;
    return bookingDetail!.status.toLowerCase() == "completed";
  }

  Widget _buildActionButtons(BuildContext context, HomeState state) {
    if (bookingDetail == null) return SizedBox.shrink();

    final isPending = _isBookingPending();
    final isConfirmed = _isBookingConfirmed();
    final isCompleted = _isBookingCompleted();
    final isCancelled = _isBookingCancelled();

    if (isCancelled) {
      return SizedBox.shrink();
    }

    if (isPending) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (bottomSheetContext) {
                      return BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: BookCancel(
                          bookingId: widget.bookingId,
                          parentBloc: context.read<HomeBloc>(),
                        ),
                      );
                    },
                  );
                },
                text: "reject".tr(),
                height: 48.h,
                margin: EdgeInsets.zero,
                isGradient: false,
                backColor: AppColor.white,
                border: Border.all(width: 1.h, color: AppColor.cE52E4C),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.cE52E4C,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                onTap: () {
                  CenterDialog.confirmBookingDialog(
                    context,
                    onConfirm: () {
                      context.read<HomeBloc>().add(
                        UpdateBookingStatusEvent(
                          bookingId: widget.bookingId,
                          status: "confirmed",
                        ),
                      );
                    },
                  );
                },
                text: "confirm".tr(),
                height: 48.h,
                margin: EdgeInsets.zero,
                loading: state is UpdateBookingStatusLoadingState,
              ),
            ),
          ],
        ),
      );
    }

    if (isConfirmed) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (bottomSheetContext) {
                      return BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: BookCancel(
                          bookingId: widget.bookingId,
                          parentBloc: context.read<HomeBloc>(),
                        ),
                      );
                    },
                  );
                },
                text: "reject".tr(),
                height: 48.h,
                margin: EdgeInsets.zero,
                isGradient: false,
                backColor: AppColor.white,
                border: Border.all(width: 1.h, color: AppColor.cE52E4C),
                style: AppTextStyle.f600s16.copyWith(
                  color: AppColor.cE52E4C,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                onTap: () {
                  CenterDialog.completeBookingDialog(
                    context,
                    onConfirm: () {
                      context.read<HomeBloc>().add(
                        UpdateBookingStatusEvent(
                          bookingId: widget.bookingId,
                          status: "completed",
                        ),
                      );
                    },
                  );
                },
                text: "completeBooking".tr(),
                height: 48.h,
                margin: EdgeInsets.zero,
                loading: state is UpdateBookingStatusLoadingState,
              ),
            ),
          ],
        ),
      );
    }

    if (isCompleted) {
      if (bookingDetail!.bookingTime == null || bookingDetail!.bookingEndTime == null) {
        return SizedBox.shrink();
      }

      _ensureTimezoneInitialized();
      final tashkent = tz.getLocation('Asia/Tashkent');
      final now = tz.TZDateTime.now(tashkent);
      final bookingTime = tz.TZDateTime.from(bookingDetail!.bookingTime!, tashkent);
      final bookingEndTime = tz.TZDateTime.from(bookingDetail!.bookingEndTime!, tashkent);

      final isSameDay = now.year == bookingTime.year &&
          now.month == bookingTime.month &&
          now.day == bookingTime.day;

      if (!isSameDay || now.isAfter(bookingEndTime)) {
        return SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: AppButton(
          onTap: () {
            context.read<HomeBloc>().add(
              ExtendTimeEvent(
                bookingId: widget.bookingId,
              ),
            );
          },
          text: "earlyClose".tr(),
          height: 48.h,
          margin: EdgeInsets.zero,
          loading: state is UpdateBookingStatusLoadingState || state is ExtendTimeLoadingState,
        ),
      );
    }

    return SizedBox.shrink();
  }
}
