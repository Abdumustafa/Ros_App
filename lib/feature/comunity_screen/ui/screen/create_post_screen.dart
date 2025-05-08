import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:graduation_project/core/helper/spaces.dart';
import 'package:graduation_project/core/services/create_post.dart';
import 'package:graduation_project/core/theming/font_weight_helper.dart';
import 'package:graduation_project/core/theming/styles.dart';
import 'package:graduation_project/feature/comunity_screen/ui/widget/camera_Button_sheet.dart';
import 'package:graduation_project/feature/comunity_screen/ui/widget/profile_image.dart';
import 'package:graduation_project/feature/comunity_screen/ui/widget/tgs_box_text.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = "/CreatePostScreen";

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? selectedItemTwo = '  public';
  String? postImage;

  List<String> itemsTwo = [
    '  public',
    '  private',
  ];

  late String profileImage;
  final RxString selectedOption = "None".obs;

  final RxBool isTagsVisible = false.obs;

  final RxBool isPostEnabled = false.obs;

  final TextEditingController postController = TextEditingController();

  Color getTagColor(String tag) {
    switch (tag) {
      case "Healing story":
        return const Color(0xffc9e9d6);
      case "Question":
        return const Color(0xffd5dbf5);
      case "Advice":
        return const Color(0xfffee2bb);
      default:
        return Colors.transparent;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['profileImage'] != null) {
        setState(() {
          profileImage = args['profileImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(60),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "   Create post",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: const Color(0xff666666),
                      fontFamily: "Merriweather",
                    ),
                  ),
                  const Spacer(),
                  Obx(() => SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed: isPostEnabled.value
                              ? () async {
                                  if (selectedOption.value == "None") {
                                    Get.snackbar(
                                      "Tag required",
                                      "Please select a tag before posting.",
                                      backgroundColor: Colors.redAccent,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                    return;
                                  }

                                  try {
                                    await CreatePostServices().createPost(
                                      tag: selectedOption.value,
                                      content: postController.text.trim(),
                                      media: postImage,
                                    );
                                    Get.back();
                                  } catch (e) {
                                    print('Error while creating post: $e');
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPostEnabled.value
                                ? Colors.blue
                                : Colors.blueGrey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            shadowColor: Colors.blue.withOpacity(0.5),
                          ),
                          child: const Text(
                            "post",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Merriweather",
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              verticalSpace(20),
              Row(
                children: [
                  if (profileImage != null)
                    ProfileImageDesign(image: profileImage!)
                  else
                    CircularProgressIndicator(),

                  horizontalSpace(5),
                  Container(
                    height: 30,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedItemTwo,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedItemTwo = newValue!;
                        });
                      },
                      items: itemsTwo
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Spacer(),
                  CameraModelBottonSheet(
                    onImagePicked: (path) {
                      setState(() {
                        postImage = path;
                      });
                    },
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: 230,
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        maxHeight: 150,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: postController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          isPostEnabled.value = value.trim().isNotEmpty;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                          hintText: "What's on your mind?",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Obx(() => selectedOption.value != "None"
                      ? Container(
                          alignment: Alignment.center,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: getTagColor(selectedOption.value),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              selectedOption.value,
                              style: TextStyles.font20greyregularMerriweather,
                            ),
                          ),
                        )
                      : const SizedBox()),
                ],
              ),
              verticalSpace(20),
              if (postImage?.isNotEmpty ?? false)
              Padding(
  padding: const EdgeInsets.all(5.0),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.file(
      File(postImage!),
      width: double.infinity,
      
      height: 200,
      fit: BoxFit.cover,
    ),
  ),
),

              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      isTagsVisible.value = !isTagsVisible.value;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      shadowColor: Colors.blue.withOpacity(0.5),
                    ),
                    child: const Text(
                      "Add tags",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Merriweather",
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() => isTagsVisible.value
                  ? Column(
                      children: [
                        RadioListTile(
                          title: const TagsBoxText(
                              tag: 'None', tagColor: Colors.white),
                          value: "None",
                          groupValue: selectedOption.value,
                          onChanged: (value) {
                            selectedOption.value = value!;
                            isTagsVisible.value = false;
                          },
                        ),
                        RadioListTile(
                          title: const TagsBoxText(
                              tag: 'Healing stories',
                              tagColor: const Color(0xffc9e9d6)),
                          value: "Healing stories",
                          groupValue: selectedOption.value,
                          onChanged: (value) {
                            selectedOption.value = value!;
                            isTagsVisible.value = false;
                          },
                        ),
                        RadioListTile(
                          title: const TagsBoxText(
                              tag: 'Question', tagColor: Color(0xffd5dbf5)),
                          value: "Question",
                          groupValue: selectedOption.value,
                          onChanged: (value) {
                            selectedOption.value = value!;
                            isTagsVisible.value = false;
                          },
                        ),
                        RadioListTile(
                          title: const TagsBoxText(
                              tag: 'Advice', tagColor: Color(0xfffee2bb)),
                          value: "Advice",
                          groupValue: selectedOption.value,
                          onChanged: (value) {
                            selectedOption.value = value!;
                            isTagsVisible.value = false;
                          },
                        ),
                      ],
                    )
                  : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
