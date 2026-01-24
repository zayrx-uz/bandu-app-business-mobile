import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPeopleCountWidget extends StatefulWidget {
  final Function(String) onSelect;
  final List<String> items;
  final String? initialItem;
  final String hintText;
  final Function(String)? onAddNew;

  const SelectPeopleCountWidget({
    super.key,
    required this.onSelect,
    required this.items,
    this.initialItem,
    required this.hintText,
    this.onAddNew,
  });

  @override
  State<SelectPeopleCountWidget> createState() => _SelectPeopleCountWidgetState();
}

class _SelectPeopleCountWidgetState extends State<SelectPeopleCountWidget>
    with SingleTickerProviderStateMixin {
  String? _selectedItem;
  bool _isExpanded = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  final GlobalKey _dropdownKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    if (widget.initialItem != null && widget.initialItem!.isNotEmpty) {
      _selectedItem = widget.initialItem;
    }
    _filteredItems = List.from(widget.items);
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isExpanded && _overlayEntry != null && mounted) {
        _overlayEntry!.markNeedsBuild();
      }
    });
  }

  bool _shouldShowAddButton() {
    final searchText = _searchController.text.trim();
    if (searchText.isEmpty) return false;

    try {
      final countText = searchText.split(' ')[0];
      final count = int.parse(countText);
      
      final searchItem = "$count ${"people".tr()}";
      final existsInList = widget.items.any((item) {
        final itemCountText = item.split(' ')[0];
        try {
          final itemCount = int.parse(itemCountText);
          return itemCount == count;
        } catch (e) {
          return false;
        }
      });

      return !existsInList;
    } catch (e) {
      return false;
    }
  }

  @override
  void didUpdateWidget(SelectPeopleCountWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialItem != widget.initialItem) {
      setState(() {
        _selectedItem = widget.initialItem;
      });
    }
    if (oldWidget.items != widget.items) {
      _filterItems();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isExpanded) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_isExpanded) return;
    setState(() => _isExpanded = true);
    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isExpanded) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      }
    });
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      _removeOverlay();
      if (mounted) {
        setState(() {
          _isExpanded = false;
          _searchController.clear();
        });
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
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        final screenHeight = mediaQuery.size.height;
        final dropdownBottom = renderBox.localToGlobal(Offset(0, size.height)).dy;
        final availableSpaceBelow = screenHeight - dropdownBottom - keyboardHeight;
        final shouldShowAbove = availableSpaceBelow < 200.h && keyboardHeight > 0;
        
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeDropdown,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: shouldShowAbove 
                      ? Offset(0, -(size.height + 4.h + 300.h))
                      : Offset(0, size.height + 4.h),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12.r),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizeTransition(
                      sizeFactor: _expandAnimation,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 300.h),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColor.greyE5, width: 1.h),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_filteredItems.isNotEmpty)
                                Flexible(
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 16.w,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: _filteredItems.length,
                                    itemBuilder: (context, index) {
                                      final item = _filteredItems[index];
                                      final isSelected = _selectedItem == item;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() => _selectedItem = item);
                                          widget.onSelect(item);
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
                                                  item,
                                                  style: AppTextStyle.f500s16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              if (_searchController.text.isNotEmpty &&
                                  _shouldShowAddButton() &&
                                  widget.onAddNew != null)
                                GestureDetector(
                                  onTap: () {
                                    widget.onAddNew!(_searchController.text);
                                    _closeDropdown();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                      horizontal: 16.w,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: AppColor.greyE5,
                                          width: 1.h,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: BoxDecoration(
                                            color: AppColor.yellowFFC,
                                            borderRadius: BorderRadius.circular(6.r),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 18.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            '"${_searchController.text}" ${"addText".tr()}',
                                            style: TextStyle(
                                              color: AppColor.yellowFFC,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (_filteredItems.isEmpty && _searchController.text.isEmpty)
                                Container(
                                  padding: EdgeInsets.all(16.w),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "noDataFound".tr(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    
    if (_isExpanded && _overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _overlayEntry != null) {
          _overlayEntry!.markNeedsBuild();
        }
      });
    }
    
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _dropdownKey,
        onTap: () {
          if (!_isExpanded) {
            _openDropdown();
          }
        },
        behavior: _isExpanded ? HitTestBehavior.translucent : HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.greyFA,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              width: 1.h,
              color: _selectedItem != null ? AppColor.yellowFFC : AppColor.greyE5,
            ),
            boxShadow: _selectedItem != null
                ? [
                    BoxShadow(
                      color: AppColor.yellowFFC.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: _isExpanded
                    ? Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus && _searchController.text.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted && _searchController.text.isEmpty) {
                                _closeDropdown();
                              }
                            });
                          }
                        },
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          style: AppTextStyle.f500s16.copyWith(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: AppTextStyle.f500s16.copyWith(
                              color: AppColor.greyA7,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            if (_selectedItem != null && value != _selectedItem) {
                              setState(() => _selectedItem = null);
                            }
                            _filterItems();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_overlayEntry != null && mounted) {
                                _overlayEntry!.markNeedsBuild();
                              }
                            });
                          },
                          onTap: () {
                            if (!_isExpanded) {
                              _openDropdown();
                            }
                          },
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty && widget.onAddNew != null) {
                              try {
                                final count = int.parse(value.trim());
                                if (count > 0) {
                                  widget.onAddNew!("$count ${"people".tr()}");
                                  _closeDropdown();
                                }
                              } catch (e) {
                              }
                            }
                          },
                        ),
                      )
                    : Text(
                        _selectedItem ?? widget.hintText,
                        style: AppTextStyle.f500s16.copyWith(
                          color: _selectedItem != null
                              ? AppColor.black09
                              : AppColor.greyA7,
                        ),
                      ),
              ),
              GestureDetector(
                onTap: _toggleDropdown,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
