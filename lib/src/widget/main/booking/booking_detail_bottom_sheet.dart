import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/extension/extension.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/booking/booking_detail_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_button.dart';
import 'package:bandu_business/src/widget/app/app_icon_button.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/custom_network_image.dart';
import 'package:bandu_business/src/widget/main/booking/book_cancel.dart';
import 'package:bandu_business/src/widget/main/qr/alice_checker_widget.dart';
import 'package:bandu_business/src/widget/dialog/center_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class BookingDetailBottomSheet extends StatefulWidget {
  final int bookingId;
  final HomeBloc? parentBloc;

  const BookingDetailBottomSheet({
    super.key,
    required this.bookingId,
    this.parentBloc,
  });

  @override
  State<BookingDetailBottomSheet> createState() => _BookingDetailBottomSheetState();
}

class _BookingDetailBottomSheetState extends State<BookingDetailBottomSheet> {
  BookingDetailData? bookingDetail;
  bool _timezoneInitialized = false;

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



  Color _getPaymentStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColor.grey58; // Grey for pending
      case 'PROCESSING':
        return AppColor.yellow8E; // Yellow/Orange for processing
      case 'PAID':
        return AppColor.green34; // Green for paid
      case 'FAILED':
        return AppColor.cE52E4C; // Red for failed
      case 'CANCELED':
      case 'CANCELLED':
        return AppColor.cE52E4C; // Red for canceled
      case 'REFUNDED':
        return AppColor.blue00; // Blue for refunded
      default:
        return AppColor.grey58;
    }
  }

  Color _getPaymentStatusBackgroundColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColor.greyF4; // Light grey background
      case 'PROCESSING':
        return AppColor.yellowEF; // Light yellow background
      case 'PAID':
        return AppColor.green34.withValues(alpha: 0.1); // Light green background
      case 'FAILED':
        return AppColor.redFF; // Light red background
      case 'CANCELED':
      case 'CANCELLED':
        return AppColor.redFF; // Light red background
      case 'REFUNDED':
        return AppColor.blue00.withValues(alpha: 0.1); // Light blue background
      default:
        return AppColor.greyF4;
    }
  }

  String _getCategoryIcon() {
    if (bookingDetail?.company.categories.isEmpty ?? true) {
      return AppIcons.placeSelect;
    }

    final firstCategory = bookingDetail!.company.categories.first;
    return HelperFunctions.getCategoryIconByIkpuCode(firstCategory.ikpuCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetBookingDetailSuccessState) {
          bookingDetail = state.data;
          setState(() {});
        } else if (state is UpdateBookingStatusSuccessState) {
          Navigator.pop(context);
          if (widget.parentBloc != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final companyId = HelperFunctions.getCompanyId() ?? 0;
              if (companyId > 0) {
                widget.parentBloc!.add(GetOwnerBookingsEvent(
                  page: 1,
                  limit: 10,
                  companyId: companyId,
                ));
              }
            });
          }
        } else if (state is CancelBookingSuccessState) {
          Navigator.pop(context);
          if (widget.parentBloc != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final companyId = HelperFunctions.getCompanyId() ?? 0;
              if (companyId > 0) {
                widget.parentBloc!.add(GetOwnerBookingsEvent(
                  page: 1,
                  limit: 10,
                  companyId: companyId,
                ));
              }
            });
          }
        } else if (state is ConfirmPaymentSuccessState) {
          context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
          if (widget.parentBloc != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final companyId = HelperFunctions.getCompanyId() ?? 0;
              if (companyId > 0) {
                widget.parentBloc!.add(GetOwnerBookingsEvent(
                  page: 1,
                  limit: 10,
                  companyId: companyId,
                ));
              }
            });
          }
        } else if (state is CheckAlicePaymentSuccessState) {
          if (state.isPaid) {
            context.read<HomeBloc>().add(GetBookingDetailEvent(bookingId: widget.bookingId));
            if (widget.parentBloc != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final companyId = HelperFunctions.getCompanyId() ?? 0;
                if (companyId > 0) {
                  widget.parentBloc!.add(GetOwnerBookingsEvent(
                    page: 1,
                    limit: 10,
                    companyId: companyId,
                  ));
                }
              });
            }
          }
        } else if (state is HomeErrorState) {
          CenterDialog.errorDialog(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is GetBookingDetailLoadingState;
        
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4.h,
                  width: 56.w,
                  margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: AppColor.greyF4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              bookingDetail?.company.name ?? "",
                              style: AppTextStyle.f500s20,
                            ),
                            SizedBox(width: 10.w,),
                            if(bookingDetail != null && bookingDetail!.payments.isNotEmpty) 
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: _getPaymentStatusBackgroundColor(bookingDetail!.payments.first.status),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    width: 1.w,
                                    color: _getPaymentStatusColor(bookingDetail!.payments.first.status).withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  bookingDetail!.payments.first.status.getLocalizedPaymentStatus(),
                                  style: AppTextStyle.f500s20.copyWith(
                                    fontSize: 14.sp,
                                    color: _getPaymentStatusColor(bookingDetail!.payments.first.status),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      AppIconButton(
                        icon: AppIcons.close,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.all(40.h),
                    child: CupertinoActivityIndicator(
                      color: AppColor.black0D,
                    ),
                  )
                else if (bookingDetail != null) ...[
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
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColor.yellowFF.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              bookingDetail!.places.first is Map
                                  ? "T-${(bookingDetail!.places.first as Map)['name'] ?? '01'}"
                                  : "T-01",
                              style: AppTextStyle.f400s16.copyWith(
                                color: AppColor.black,
                              ),
                            ),
                          ),
                        if (bookingDetail!.places.isNotEmpty) SizedBox(height: 12.h),
                        _getCategoryIcon().contains('assets/images/')
                            ? Image.asset(
                                _getCategoryIcon(),
                                height: 88.h,
                                width: 80.h,
                                fit: BoxFit.contain,
                              )
                            : AppSvgAsset(
                                _getCategoryIcon(),
                                height: 88.h,
                                width: 80.h,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
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
                                style: AppTextStyle.f500s16.copyWith(
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
                                  bookingDetail!.bookingTime != null ? _formatDateTime(bookingDetail!.bookingTime, bookingDetail!.bookingEndTime) : "",
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
                                style: AppTextStyle.f500s16.copyWith(
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
                                  _formatDateTime(bookingDetail!.bookingTime, bookingDetail!.bookingEndTime),
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
                                "comment".tr(),
                                style: AppTextStyle.f500s16.copyWith(
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
                        final imageUrl = resource.metadata is Map && resource.metadata['images'] != null
                            ? (resource.metadata['images'] as List).isNotEmpty
                                ? (resource.metadata['images'] as List).first['url'] ?? ""
                                : ""
                            : "";
                        
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
                                            "${resource.timeSlotDurationMinutes} ${resource.timeSlotDurationMinutes == 1 ? "minute".tr() : "minutes".tr()}",
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
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "${resource.price.priceFormat()} UZS",
                                      style: AppTextStyle.f500s16,
                                    ),
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
                  if (!_isBookingCancelled() && !_isPaymentPaid()) ...[
                    _buildActionButtons(context, state),
                  ],
                  SizedBox(height: 24.h),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isPaymentPaid() {
    if (bookingDetail == null || bookingDetail!.payments.isEmpty) return false;
    final payment = bookingDetail!.payments.firstWhere(
      (p) => p.id == bookingDetail!.paymentId,
      orElse: () => bookingDetail!.payments.first,
    );
    return payment.status.toUpperCase() == "PAID";
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

  Widget _buildActionButtons(BuildContext context, HomeState state) {
    final isPending = _isBookingPending();
    final isConfirmed = _isBookingConfirmed();
    
    if (_isBookingCancelled()) {
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
                          parentBloc: widget.parentBloc ?? context.read<HomeBloc>(),
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
        child: Column(
          children: [
            Row(
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
                              parentBloc: widget.parentBloc ?? context.read<HomeBloc>(),
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
                  child: _buildPaymentConfirmButton(context, state),
                ),
              ],
            ),
            // if (!_isPaymentPaid() && bookingDetail?.paymentId != null) ...[
            //   SizedBox(height: 12.h),
            //   _buildPaymentConfirmButton(context, state),
            // ],
          ],
        ),
      );
    }
    
    return SizedBox.shrink();
  }

  Widget _buildPaymentConfirmButton(BuildContext context, HomeState state) {
    final isConfirmingPayment = state is ConfirmPaymentLoadingState;
    final isPaid = _isPaymentPaid();
    final isConfirmed = _isBookingConfirmed();
    
    if (isPaid || !isConfirmed || bookingDetail?.paymentId == null) {
      return SizedBox.shrink();
    }

    return AppButton(
      onTap: () {
        if (bookingDetail?.paymentId != null) {
          CenterDialog.confirmPaymentDialog(
            context,
            paymentId: bookingDetail!.paymentId!,
            onConfirm: () {
              context.read<HomeBloc>().add(
                ConfirmPaymentEvent(paymentId: bookingDetail!.paymentId!),
              );
            },
          );
        }
      },
      text: "confirmPayment".tr(),
      height: 48.h,
      margin: EdgeInsets.zero,
      loading: isConfirmingPayment,
    );
  }
}
