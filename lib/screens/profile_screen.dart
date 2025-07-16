import 'package:flutter/material.dart';
import 'package:vocaboo/screens/faqs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProfileListTile> plt = [
      ProfileListTile(
        title: 'Personal Information',
        subtitle: 'Control Your Account Security here',
        icondata: Icons.person,
        fn: () {},
      ),
      ProfileListTile(
        title: 'Language optiond',
        subtitle: 'Choose which language to use in the app',
        icondata: Icons.language,
        fn: () {},
      ),
      ProfileListTile(
        title: 'Change Theme',
        subtitle: 'Change the theme to your liking',
        icondata: Icons.palette,
        fn: () {},
      ),
      ProfileListTile(
        title: 'Delete Account',
        subtitle: 'Check how to delete your account',
        icondata: Icons.delete,
        fn: () {},
      ),
      ProfileListTile(
        title: 'Support Center',
        subtitle: 'See how to contact us',
        icondata: Icons.messenger,
        fn: () {},
      ),
      ProfileListTile(
        title: 'FQA',
        subtitle: 'See Frequently Asked Questions',
        icondata: Icons.help_outlined,
        fn: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => const FAQScreen()),
          );
        },
      ),
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text("Emma Watson"),
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                subtitle: Text('emmawatson@gmail.com'),
                subtitleTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                leading: SizedBox(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://celebmafia.com/wp-content/uploads/2017/02/emma-watson-photoshoot-february-2017-1.jpg',
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: plt.length,
                        itemBuilder: (context, index) {
                          return plt[index];
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            Text('   Log Out', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
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

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icondata;
  final VoidCallback fn;
  const ProfileListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icondata,
    required this.fn,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subtitle: Text(subtitle),
      subtitleTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: Colors.black54,
      ),
      leading: Icon(icondata, color: Colors.black),
      trailing: IconButton(
        onPressed: fn,
        icon: Icon(Icons.arrow_forward),
        color: Colors.grey,
      ),
    );
  }
}
