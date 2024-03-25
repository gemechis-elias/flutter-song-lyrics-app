import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import 'dialog_upload.dart';

class EditLayricsPage extends StatefulWidget {
  EditLayricsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EditLayricsPageState createState() => _EditLayricsPageState();
}

class _EditLayricsPageState extends State<EditLayricsPage> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 54, 53, 53),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (kIsWeb) {
                    controller.reloadWeb();
                  } else {
                    controller.editorController!.reload();
                  }
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //controller.toggleCodeView();
            DatabaseReference ref =
                FirebaseDatabase.instance.ref("songs").push();

            controller.getText().then((String value) async {
              log("HTML Value: $value");

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UploadDialog(value: value);
                },
              );
            });
          },
          child: const Icon(Icons.upload,
              color: Color.fromARGB(255, 21, 21, 21),
              size: 30), //Icon(Icons.code),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Your text here...',
                  shouldEnsureVisible: false,
                  //initialText: "<p>text content initial, if any</p>",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.aboveEditor, //by default
                  toolbarType: ToolbarType.nativeScrollable, //by default
                  onButtonPressed:
                      (ButtonType type, bool? status, Function? updateStatus) {
                    log("button '${describeEnum(type)}' pressed, the current selected status is $status");
                    return true;
                  },
                  onDropdownChanged: (DropdownType type, dynamic changed,
                      Function(dynamic)? updateSelectedItem) {
                    log("dropdown '${describeEnum(type)}' changed to $changed");
                    return true;
                  },

                  mediaUploadInterceptor:
                      (PlatformFile file, InsertFileType type) async {
                    log(file.name.toString()); //filename
                    log(file.size.toString()); //size in bytes
                    log(file.extension
                        .toString()); //file extension (eg jpeg or mp4)
                    return true;
                  },
                ),
                otherOptions: const OtherOptions(height: 550),
                callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                  log('html before change is $currentHtml');
                }, onChangeContent: (String? changed) {
                  log('content changed to $changed');
                }, onChangeCodeview: (String? changed) {
                  log('code changed to $changed');
                }, onChangeSelection: (EditorSettings settings) {
                  log('parent element is ${settings.parentElement}');
                  log('font name is ${settings.fontName}');
                }, onDialogShown: () {
                  log('dialog shown');
                }, onEnter: () {
                  log('enter/return pressed');
                }, onFocus: () {
                  log('editor focused');
                }, onBlur: () {
                  log('editor unfocused');
                }, onBlurCodeview: () {
                  log('codeview either focused or unfocused');
                }, onInit: () {
                  log('init');
                },
                    //this is commented because it overrides the default Summernote handlers
                    /*onImageLinkInsert: (String? url) {
                    log(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    log(file.name);
                    log(file.size);
                    log(file.type);
                    log(file.base64);
                  },*/
                    onImageUploadError: (FileUpload? file, String? base64Str,
                        UploadError error) {
                  log(describeEnum(error));
                  log(base64Str ?? '');
                  if (file != null) {
                    log(file.name.toString());
                    log(file.size.toString());
                    log(file.type.toString());
                  }
                }, onKeyDown: (int? keyCode) {
                  log('$keyCode key downed');
                  log('current character count: ${controller.characterCount}');
                }, onKeyUp: (int? keyCode) {
                  log('$keyCode key released');
                }, onMouseDown: () {
                  log('mouse downed');
                }, onMouseUp: () {
                  log('mouse released');
                }, onNavigationRequestMobile: (String url) {
                  log(url);
                  return NavigationActionPolicy.ALLOW;
                }, onPaste: () {
                  log('pasted into editor');
                }, onScroll: () {
                  log('editor scrolled');
                }),
                plugins: [
                  SummernoteAtMention(
                      getSuggestionsMobile: (String value) {
                        var mentions = <String>['test1', 'test2', 'test3'];
                        return mentions
                            .where((element) => element.contains(value))
                            .toList();
                      },
                      mentionsWeb: ['test1', 'test2', 'test3'],
                      onSelect: (String value) {
                        log(value);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
