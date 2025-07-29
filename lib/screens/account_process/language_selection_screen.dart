import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vocaboo/provider/language_provider.dart';
import 'package:vocaboo/provider/user_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languages = languageProvider.languages;
    final selectedCode = languageProvider.selectedLanguageCode;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected = selectedCode == language['code'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      child: ListTile(
                        selected: isSelected,
                        title: Text(language['name']!),
                        leading: SvgPicture.asset(
                          'assets/flags/${language['code']}.svg',
                          width: 35,
                          height: 35,
                          fit: BoxFit.contain,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        titleTextStyle:
                            isSelected
                                ? TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                )
                                : TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                        tileColor:
                            isSelected
                                ? Colors.blue.shade500
                                : Colors.grey.shade100,
                        trailing:
                            isSelected
                                ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                                : null,
                        onTap: () async {
                          final supportedLanguages = ['ja', 'en', 'es', 'fr'];
                          final isSupported = supportedLanguages.contains(
                            language['code'],
                          );

                          if (!isSupported) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Coming soon!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          languageProvider.setSelectedLanguage(
                            language['code']!,
                          );
                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).updateLanguage(
                            languageProvider.selectedLanguageName!,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed:
                    Provider.of<UserProvider>(context).languageName != null
                        ? () => Navigator.pushNamed(context, '/confirmation')
                        : null,
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
