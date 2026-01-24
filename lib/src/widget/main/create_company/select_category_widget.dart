import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/model/api/main/home/category_model.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Function(int) onSelect;
  final List<CategoryData> item;
  final int? selectedId;

  const SelectCategoryWidget({
    super.key,
    required this.onSelect,
    required this.item,
    this.selectedId,
  });

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget>
    with SingleTickerProviderStateMixin {
  CategoryData? _selectedItem;
  bool _isExpanded = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _updateSelectedItem();
  }

  @override
  void didUpdateWidget(SelectCategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId ||
        oldWidget.item != widget.item) {
      _updateSelectedItem();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _updateSelectedItem() {
    CategoryData? newSelectedItem;
    if (widget.selectedId != null && widget.item.isNotEmpty) {
      try {
        newSelectedItem = widget.item.firstWhere(
              (cat) => cat.id == widget.selectedId,
        );
      } catch (e) {
        newSelectedItem = null;
      }
    }

    if (mounted && _selectedItem?.id != newSelectedItem?.id) {
      setState(() {
        _selectedItem = newSelectedItem;
      });
    }
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() => _isExpanded = true);
    _animationController.forward();

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      _removeOverlay();
      if (mounted) {
        setState(() => _isExpanded = false);
      }
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox =
    _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4.h),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8.r),
                  child: FadeTransition(
                    opacity: _expandAnimation,
                    child: SizeTransition(
                      sizeFactor: _expandAnimation,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 300.h),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColor.greyE5, width: 1.h),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 16.w,
                            ),
                            shrinkWrap: true,
                            itemCount: widget.item.length,
                            itemBuilder: (context, index) {
                              final item = widget.item[index];
                              final isSelected = _selectedItem?.id == item.id;

                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedItem = item);
                                  widget.onSelect(item.id);
                                  _closeDropdown();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 16.h,
                                        width: 16.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColor.greyFA,
                                          border: Border.all(
                                            width: isSelected ? 4.h : 1.h,
                                            color: isSelected
                                                ? AppColor.yellowFFC
                                                : AppColor.greyE5,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: AppTextStyle.f400s16.copyWith(
                                            fontSize: isTablet(context)
                                                ? 12.sp
                                                : 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "selectCategory".tr(),
            style: AppTextStyle.f500s16.copyWith(
              fontSize: isTablet(context) ? 12.sp : 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              key: _dropdownKey,
              onTap: _toggleDropdown,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColor.greyFA,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(width: 1.h, color: AppColor.greyE5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedItem?.name ?? "selectCategory".tr(),
                        style: AppTextStyle.f400s16.copyWith(
                          fontSize: isTablet(context) ? 12.sp : 16.sp,
                          color: _selectedItem != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: AppSvgAsset(AppIcons.bottom),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}