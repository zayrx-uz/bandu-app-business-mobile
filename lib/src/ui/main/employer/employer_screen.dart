import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/theme/app_color.dart';
import 'package:bandu_business/src/ui/main/employer/screen/add_employee_screen.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:bandu_business/src/widget/app/empty_widget.dart';
import 'package:bandu_business/src/widget/app/top_bar_widget.dart';
import 'package:bandu_business/src/widget/main/employer/employer_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});

  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  List<EmployeeItemData>? data;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    BlocProvider.of<HomeBloc>(context).add(GetEmployeeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetEmployeeSuccessState) {
            data = state.data;
          }
        },
        builder: (context, state) {
          if (data == null) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppColor.black,
              ),
            );
          }
          return Column(
            children: [
              TopBarWidget(),
              if (data!.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Column(
                      children: [
                        for (int i = 0; i < data!.length; i++)
                          EmployerItemWidget(data: data![i]),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Center(
                      child : EmptyWidget(text: "No places available. Please add a place" , icon: AppIcons.employe,)
                  ),
                ),
            ],
          );
        },
      ),

      floatingActionButton: CupertinoButton(
        onPressed: () {
          CupertinoScaffold.showCupertinoModalBottomSheet(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: const AddEmployeeScreen(),
              );
            },
          ).then((on) {
            getData();
          });
        },
        padding: EdgeInsets.zero,
        child: Container(
          height: 48.h,
          width: 48.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColor.buttonGradient,
          ),
          child: Center(
            child: AppSvgAsset(AppIcons.plus, color: AppColor.white),
          ),
        ),
      ),
    );
  }
}
