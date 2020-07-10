import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/account.dart';
import 'package:flutter_social_app/utils/app_constants.dart';
import 'package:flutter_social_app/viewmodels/drawer_navigation_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/friends_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/global_posts_viewmodel.dart';
import 'package:flutter_social_app/viewmodels/login_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'components/home_page.dart';
import 'components/profile_page.dart';
import 'components/settings_page.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GlobalPostViewModel>(context,listen: false).initPostList();
      Provider.of<FriendsPostsViewModel>(context,listen: false).initPostList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.purple,
        title: Text(
          Provider.of<DrawerNavigationViewModel>(context).appBarTitle,
          style:
              GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<DrawerNavigationViewModel>(
        builder: (context, DrawerNavigationViewModel viewModel, child) {
          if (viewModel.navigationState == DrawerNavigationState.HomePage) {
            return HomePage();
          } else if (viewModel.navigationState ==
              DrawerNavigationState.ProfilePage) {
            return ProfilePage();
          } else if (viewModel.navigationState ==
              DrawerNavigationState.SettingsPage) {
            return SettingsPage();
          } else if (viewModel.navigationState == DrawerNavigationState.About) {
            return HomePage();
          } else if (viewModel.navigationState ==
              DrawerNavigationState.RateUs) {
            return HomePage();
          }
          return HomePage();
        },
      ),
    );
  }

  Drawer _buildDrawer() {
    DrawerNavigationViewModel navigationViewModel =
        Provider.of<DrawerNavigationViewModel>(context);
    Account account = Provider.of<LoginViewModel>(context).accountModel;
    bool profileImageControl = false;
    if (account.user!=null&&account.user.profileImage != null) {
      profileImageControl = true;
    }
    return Drawer(
      elevation: 5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                profileImageControl
                    ? ClipOval(
                        child: Image.network(
                          AppConstant.IMAGE_URL + account.user.profileImage ??
                              '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                          'assets/images/icon.jpg',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                Spacer(),
                Text(
                  account.user.name ?? '',
                  style:
                      GoogleFonts.montserrat(fontSize: 16, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  account.user.email ?? '',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, color: Colors.white60),
                ),
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Colors.blue[800],
                  Colors.blue[600],
                  Colors.blue[500]
                ],
                    stops: [
                  0.5,
                  0.5,
                  1
                ])),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              navigationViewModel.changePage(DrawerNavigationState.HomePage);
            },
            leading: Icon(
              Icons.home,
              size: 24,
            ),
            title: Text(
              'Home',
              style: GoogleFonts.montserrat(
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              navigationViewModel.changePage(DrawerNavigationState.ProfilePage);
            },
            leading: Icon(
              Icons.account_circle,
              size: 24,
            ),
            title: Text(
              'Profile',
              style: GoogleFonts.montserrat(
                fontSize: 16,
              ),
            ),
          ),
          Divider(
            thickness: 1.5,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              navigationViewModel
                  .changePage(DrawerNavigationState.SettingsPage);
            },
            leading: Icon(
              Icons.settings,
              size: 24,
            ),
            title: Text(
              'Settings',
              style: GoogleFonts.montserrat(
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              navigationViewModel.changePage(DrawerNavigationState.About);
            },
            leading: Icon(
              Icons.info,
              size: 24,
            ),
            title: Text(
              'About',
              style: GoogleFonts.montserrat(
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              navigationViewModel.changePage(DrawerNavigationState.RateUs);
            },
            leading: Icon(
              Icons.star,
              size: 24,
            ),
            title: Text(
              'Rate Us',
              style: GoogleFonts.montserrat(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
