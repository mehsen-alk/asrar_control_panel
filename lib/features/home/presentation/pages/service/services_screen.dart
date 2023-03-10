import 'package:asrar_control_panel/config/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/routes_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../blocs/company/company_bloc.dart';
import '../../widgets/control_panel_button.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.services.tr(context)),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              ControlPanelButton(
                buttonTitle: AppStrings.addServicesCompany.tr(context),
                onTap: () => Navigator.pushNamed(
                    context, Routes.addCompanyRoute),
              ),
              ControlPanelButton(
                buttonTitle: AppStrings.companies.tr(context),
                onTap: () {
                  Navigator.pushNamed(context, Routes.deleteCompanyRoute);
                  BlocProvider.of<CompanyBloc>(context).add(GetCompaniesListEvent());
                },
              )
            ],
          ),
          Column(
            children: [
              ControlPanelButton(
                buttonTitle: AppStrings.addService.tr(context),
                onTap: () {
                  BlocProvider.of<CompanyBloc>(context).add(GetCompaniesListEvent());
                  Navigator.pushNamed(context, Routes.addServicesRoute);
                },
              ),          
            ],
          )
        ],
      ),
    );
  }
}
