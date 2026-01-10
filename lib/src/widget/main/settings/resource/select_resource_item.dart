import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/device_helper/device_helper.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/main/home/resource_category_model.dart' as resource_category;
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/theme/const_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectResourceWidget extends StatefulWidget {
  final Function(int)? onCategorySelected;

  const SelectResourceWidget({super.key, this.onCategorySelected});

  @override
  State<SelectResourceWidget> createState() => _SelectResourceWidgetState();
}

class _SelectResourceWidgetState extends State<SelectResourceWidget> with TickerProviderStateMixin {
  List<SelectionLevel> selectionLevels = [];
  Map<int, AnimationController> animationControllers = {};
  Map<int, Animation<double>> expandAnimations = {};
  Map<int, Animation<double>> fadeAnimations = {};
  Map<int, TextEditingController> searchControllers = {};
  Map<int, List<CategoryItem>> filteredItems = {};
  List<resource_category.ResourceCategoryData>? categories;

  void _loadCategories(List<resource_category.ResourceCategoryData> data) {
    categories = data;
    
    final categoryMap = <int, CategoryItem>{};
    final topLevelCategories = <CategoryItem>[];
    
    for (var cat in data) {
      if (cat.parent == null) {
        final children = <CategoryItem>[];
        for (var child in cat.children) {
          final childItem = CategoryItem(
            id: child.id,
            name: child.name,
            children: [],
          );
          children.add(childItem);
          categoryMap[child.id] = childItem;
        }
        
        final item = CategoryItem(
          id: cat.id,
          name: cat.name,
          children: children,
        );
        
        categoryMap[cat.id] = item;
        topLevelCategories.add(item);
      }
    }
    
    for (var cat in data) {
      if (cat.parent != null) {
        final parentId = cat.parent!.id;
        if (categoryMap.containsKey(parentId)) {
          final children = <CategoryItem>[];
          for (var child in cat.children) {
            if (!categoryMap.containsKey(child.id)) {
              final childItem = CategoryItem(
                id: child.id,
                name: child.name,
                children: [],
              );
              children.add(childItem);
              categoryMap[child.id] = childItem;
            }
          }
          
          if (!categoryMap.containsKey(cat.id)) {
            final item = CategoryItem(
              id: cat.id,
              name: cat.name,
              children: children,
            );
            categoryMap[cat.id] = item;
            categoryMap[parentId]!.children.add(item);
          }
        }
      }
    }

    if (selectionLevels.isEmpty) {
      selectionLevels.add(SelectionLevel(
        items: topLevelCategories,
        selectedItem: null,
        isExpanded: false,
        level: 0,
      ));
      _createAnimationController(0);
      _createSearchController(0);
      filteredItems[0] = topLevelCategories;
    } else {
      setState(() {
        selectionLevels[0].items = topLevelCategories;
        filteredItems[0] = topLevelCategories;
        selectionLevels[0].selectedItem = null;
        searchControllers[0]?.clear();
        
        if (selectionLevels.length > 1) {
          for (int i = 1; i < selectionLevels.length; i++) {
            animationControllers[i]?.dispose();
            animationControllers.remove(i);
            expandAnimations.remove(i);
            fadeAnimations.remove(i);
            searchControllers[i]?.dispose();
            searchControllers.remove(i);
            filteredItems.remove(i);
          }
          selectionLevels.removeRange(1, selectionLevels.length);
        }
        
        _filterItems(0);
      });
    }
  }

  void _createSearchController(int level) {
    searchControllers[level] = TextEditingController();
    searchControllers[level]!.addListener(() {
      _filterItems(level);
    });
  }

  void _filterItems(int level) {
    final query = searchControllers[level]!.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredItems[level] = selectionLevels[level].items;
      } else {
        filteredItems[level] = selectionLevels[level].items
            .where((item) => item.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _createAnimationController(int level) {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    animationControllers[level] = controller;
    expandAnimations[level] = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    fadeAnimations[level] = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void toggleExpand(int level) {
    setState(() {
      selectionLevels[level].isExpanded = !selectionLevels[level].isExpanded;
      if (selectionLevels[level].isExpanded) {
        animationControllers[level]?.forward();
      } else {
        animationControllers[level]?.reverse();
      }
    });
  }

  void updateSearchText(int level, String text) {
    _filterItems(level);
  }

  void selectItem(CategoryItem item, int level) async {
    setState(() {
      for (int i = level + 1; i < selectionLevels.length; i++) {
        selectionLevels[i].selectedItem = null;
      }
      
      searchControllers[level]!.text = item.name;
      selectionLevels[level].selectedItem = item;
      selectionLevels[level].isExpanded = false;
      filteredItems[level] = selectionLevels[level].items;
    });

    await animationControllers[level]?.reverse();

    if (item.children.isNotEmpty) {
      setState(() {
        if (selectionLevels.length > level + 1) {
          for (int i = level + 1; i < selectionLevels.length; i++) {
            animationControllers[i]?.dispose();
            animationControllers.remove(i);
            expandAnimations.remove(i);
            fadeAnimations.remove(i);
            searchControllers[i]?.dispose();
            searchControllers.remove(i);
            filteredItems.remove(i);
          }
          selectionLevels.removeRange(level + 1, selectionLevels.length);
        }

        final newLevel = level + 1;
        selectionLevels.add(SelectionLevel(
          items: item.children,
          selectedItem: null,
          isExpanded: true,
          level: newLevel,
        ));
        _createAnimationController(newLevel);
        _createSearchController(newLevel);
        filteredItems[newLevel] = item.children;

        Future.delayed(const Duration(milliseconds: 100), () {
          animationControllers[newLevel]?.forward();
        });
      });
    } else {
      setState(() {
        if (selectionLevels.length > level + 1) {
          for (int i = level + 1; i < selectionLevels.length; i++) {
            animationControllers[i]?.dispose();
            animationControllers.remove(i);
            expandAnimations.remove(i);
            fadeAnimations.remove(i);
            searchControllers[i]?.dispose();
            searchControllers.remove(i);
            filteredItems.remove(i);
          }
          selectionLevels.removeRange(level + 1, selectionLevels.length);
        }
      });
      
      if (widget.onCategorySelected != null && item.id > 0) {
        widget.onCategorySelected!(item.id);
      }
    }
  }

  void addNewItem(int level, String itemName) {
    if (itemName.trim().isEmpty) return;

    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId == 0) return;

    final newItem = CategoryItem(
      id: 0,
      name: itemName.trim(),
      children: [],
    );

    setState(() {
      selectionLevels[level].items.add(newItem);
      _filterItems(level);
      searchControllers[level]?.clear();
    });

    context.read<HomeBloc>().add(CreateResourceCategoryEvent(
      name: itemName.trim(),
      companyId: companyId,
    ));
  }

  void addNewItemToSelectedParent(int level, String itemName) {
    if (itemName.trim().isEmpty) return;

    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId == 0) return;

    int? parentId;
    if (level > 0 && selectionLevels[level - 1].selectedItem != null) {
      parentId = selectionLevels[level - 1].selectedItem!.id;
    }

    final newItem = CategoryItem(
      id: 0,
      name: itemName.trim(),
      children: [],
    );

    setState(() {
      selectionLevels[level].items.add(newItem);
      filteredItems[level] = selectionLevels[level].items;
      searchControllers[level]?.clear();
    });

    context.read<HomeBloc>().add(CreateResourceCategoryEvent(
      name: itemName.trim(),
      parentId: parentId,
      companyId: companyId,
    ));
  }

  @override
  void initState() {
    super.initState();
    final companyId = HelperFunctions.getCompanyId() ?? 0;
    if (companyId > 0) {
      context.read<HomeBloc>().add(GetResourceCategoryEvent(companyId: companyId));
    }
  }

  @override
  void dispose() {
    for (var controller in animationControllers.values) {
      controller.dispose();
    }
    for (var controller in searchControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is GetResourceCategorySuccessState) {
          _loadCategories(state.data);
        }
        if (state is CreateResourceCategorySuccessState) {
          final companyId = HelperFunctions.getCompanyId() ?? 0;
          if (companyId > 0) {
            context.read<HomeBloc>().add(GetResourceCategoryEvent(companyId: companyId));
          }
        }
        if (state is DeleteResourceCategorySuccessState) {
          final companyId = HelperFunctions.getCompanyId() ?? 0;
          if (companyId > 0) {
            context.read<HomeBloc>().add(GetResourceCategoryEvent(companyId: companyId));
          }
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is GetResourceCategoryLoadingState && selectionLevels.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (selectionLevels.isEmpty) {
            return SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int levelIndex = 0; levelIndex < selectionLevels.length; levelIndex++)
                  _buildLevelWidget(levelIndex),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelWidget(int levelIndex) {
    final level = selectionLevels[levelIndex];
    final controller = animationControllers[levelIndex];
    final expandAnimation = expandAnimations[levelIndex];
    final fadeAnimation = fadeAnimations[levelIndex];

    return AnimatedSize(
      key: ValueKey('level-$levelIndex'),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 40 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (levelIndex == 0)
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Text(
                    "Resource Category",
                    style: AppTextStyle.f500s16.copyWith(
                      color: AppColor.black09,
                      fontSize: DeviceHelper.isTablet(context) ? 12.sp : 16.sp,
                    ),
                  ),
                ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                height: 48.h,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColor.greyFA,
                  border: Border.all(
                    width: 1.h,
                    color: level.selectedItem != null ? AppColor.yellowFFC : AppColor.greyE5,
                  ),
                  boxShadow: level.selectedItem != null
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
                      child: TextField(
                        controller: searchControllers[levelIndex],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Qidirish yoki tanlang...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          if (!level.isExpanded) {
                            setState(() {
                              level.isExpanded = true;
                            });
                            animationControllers[levelIndex]?.forward();
                          }

                          if (level.selectedItem != null && value != level.selectedItem!.name) {
                            setState(() {
                              level.selectedItem = null;
                            });
                          }

                          updateSearchText(levelIndex, value);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () => toggleExpand(levelIndex),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: AnimatedRotation(
                          turns: level.isExpanded ? 0.5 : 0.0,
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
              SizedBox(height: 10.h),
              if (controller != null && expandAnimation != null && fadeAnimation != null)
                SizeTransition(
                  sizeFactor: expandAnimation,
                  axisAlignment: -1.0,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(width: 1.w, color: AppColor.cE5E7E5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.h,
                        children: [
                          if (filteredItems[levelIndex]?.isNotEmpty ?? false)
                            for (int i = 0; i < filteredItems[levelIndex]!.length; i++)
                              TweenAnimationBuilder<double>(
                                key: ValueKey('item-$levelIndex-$i-${filteredItems[levelIndex]![i].id}'),
                                duration: Duration(milliseconds: 300 + (i * 60)),
                                tween: Tween(begin: 0.0, end: 1.0),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(30 * (1 - value), 0),
                                    child: Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: GestureDetector(
                                  onTap: () => selectItem(filteredItems[levelIndex]![i], levelIndex),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOutCubic,
                                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                    decoration: BoxDecoration(
                                      color: level.selectedItem?.id == filteredItems[levelIndex]![i].id
                                          ? AppColor.yellowFFC.withValues(alpha: 0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            filteredItems[levelIndex]![i].name,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                final companyId = HelperFunctions.getCompanyId() ?? 0;
                                                if (companyId > 0 && filteredItems[levelIndex]![i].id > 0) {
                                                  context.read<HomeBloc>().add(
                                                    DeleteResourceCategoryEvent(id: filteredItems[levelIndex]![i].id),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4.w),
                                                decoration: BoxDecoration(
                                                  color: AppColor.redED.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6.r),
                                                ),
                                                child: Icon(
                                                  Icons.delete_outline,
                                                  size: 18.sp,
                                                  color: AppColor.redED,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            if (filteredItems[levelIndex]![i].children.isNotEmpty)
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 16.sp,
                                                color: level.selectedItem?.id == filteredItems[levelIndex]![i].id
                                                    ? AppColor.yellowFFC
                                                    : Colors.grey,
                                              )
                                            else
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                width: 15.w,
                                                height: 15.w,
                                                decoration: BoxDecoration(
                                                  color: level.selectedItem?.id == filteredItems[levelIndex]![i].id
                                                      ? AppColor.yellowFFC
                                                      : Colors.grey,
                                                  borderRadius: BorderRadius.circular(100.r),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          if (level.selectedItem != null &&
                              level.selectedItem!.children.isEmpty &&
                              searchControllers[levelIndex]!.text.isNotEmpty)
                            TweenAnimationBuilder<double>(
                              key: ValueKey('add-empty-$levelIndex'),
                              duration: const Duration(milliseconds: 400),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(30 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  addNewItemToSelectedParent(levelIndex, searchControllers[levelIndex]!.text);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOutCubic,
                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '"${searchControllers[levelIndex]!.text}" qo\'shish',
                                          style: TextStyle(
                                            color: AppColor.yellowFFC,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (searchControllers[levelIndex]!.text.isNotEmpty &&
                              (level.selectedItem == null || level.selectedItem!.children.isNotEmpty))
                            TweenAnimationBuilder<double>(
                              key: ValueKey('add-btn-$levelIndex'),
                              duration: const Duration(milliseconds: 400),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(30 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  addNewItem(levelIndex, searchControllers[levelIndex]!.text);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOutCubic,
                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '"${searchControllers[levelIndex]!.text}" qo\'shish',
                                          style: TextStyle(
                                            color: AppColor.yellowFFC,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (filteredItems[levelIndex]?.isEmpty ?? true)
                            if (searchControllers[levelIndex]!.text.isEmpty)
                              Container(
                                padding: EdgeInsets.all(16.w),
                                alignment: Alignment.center,
                                child: Text(
                                  "Ma'lumot topilmadi",
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
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionLevel {
  List<CategoryItem> items;
  CategoryItem? selectedItem;
  bool isExpanded;
  int level;

  SelectionLevel({
    required this.items,
    required this.selectedItem,
    required this.isExpanded,
    required this.level,
  });
}

class CategoryItem {
  int id;
  String name;
  List<CategoryItem> children;

  CategoryItem({
    required this.id,
    required this.name,
    required this.children,
  });
}
