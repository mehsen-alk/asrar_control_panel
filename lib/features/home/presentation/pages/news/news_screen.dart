import 'package:asrar_control_panel/config/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/routes_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../blocs/news_bloc/news_bloc.dart';
import '../../widgets/control_panel_button.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ControlPanelButton(
            buttonTitle: AppStrings.addNews.tr(context),
            onTap: () {
              Navigator.pushNamed(context, Routes.addNewsRoute);
            },
          ),
          ControlPanelButton(
            buttonTitle: AppStrings.news.tr(context),
            onTap: () {
              BlocProvider.of<NewsBloc>(context).add(GetNewsListEvent());
              Navigator.pushNamed(context, Routes.deleteNewsRoute);
            },
          ),
        ],
      ),
    );
  }
}
