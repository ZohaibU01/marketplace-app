import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'dart:convert';
import '../model/forum_model.dart';

class ForumController extends GetxController {
  var isLoading = false.obs;
  var forumPosts = <ForumPost>[].obs;
  var imagePath = ''.obs; // For handling the selected image
  var tags = <String>[].obs; // For handling selected tags
  TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchForumPosts();
  }

  List<ForumPost> get getLikedForumPost => forumPosts.where((f) => f.likes.any((l) => l.userId == DataStroge.currentUser.value!.id,),).toList();

  // Fetch forum posts
  Future<void> fetchForumPosts() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('forum', token: DataStroge.accesstoken.value);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          forumPosts.value = (responseData['data'] as List)
              .map((item) => ForumPost.fromJson(item))
              .toList();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to fetch forum posts.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch forum posts.");
      }
    } catch (e,s) {
      print(e.toString() + s.toString());
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a forum post
  Future<void> deletePost(int postId) async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(
        'forum/$postId',
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          Get.snackbar("Success", responseData['message'] ?? "Post deleted successfully.");
          fetchForumPosts(); // Refresh posts
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to delete post.");
        }
      } else {
        Get.snackbar("Error", "Failed to delete post. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Edit forum post
  Future<bool> editForum(int postId) async {
    if (descriptionController.text.isEmpty || tags.isEmpty) {
      Get.snackbar("Error", "Please provide a description and at least one tag.");
      return false;
    }

    isLoading.value = true;

    try {
      final fields = {
        "caption": descriptionController.text,
        "id": postId.toString(),
      };

      // Add the list of tags to the fields
      for (int i = 0; i < tags.length; i++) {
        fields["tags[$i]"] = tags[i];
      }

      var files = <File>[];
      if(!imagePath.startsWith('http')){
        files = imagePath.value.isNotEmpty ? [File(imagePath.value)] : <File>[];
      }

      final response = await ApiService.postMultiPart(
        'update-forum',
        fields: fields,
        files: files,
        token: DataStroge.accesstoken.value,
        fileFieldName: "image"
      );

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);

        if (jsonResponse['error'] == false) {
          Get.snackbar("Success", jsonResponse['message'] ?? "Post updated successfully.");
          fetchForumPosts(); // Refresh posts after editing
          return true;
        } else {
          Get.snackbar("Error", jsonResponse['message'] ?? "Failed to update post.");
          return false;
        }
      }
      else {
        Get.snackbar("Error", "Failed to update post. Status Code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likePost(int postId) async {
    // Find the post
    final postIndex = forumPosts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;
    final post = forumPosts[postIndex];
    final currentUserId = DataStroge.currentUser.value!.id;
    final alreadyLiked = post.likes.any((l) => l.userId == currentUserId);
    // Optimistically update
    final originalLikes = List<Like>.from(post.likes);
    if (alreadyLiked) {
      post.likes.removeWhere((l) => l.userId == currentUserId);
    } else {
      post.likes.add(Like(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: currentUserId,
        likeableType: 'ForumPost',
        likeableId: postId,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
    }
    forumPosts[postIndex] = post.copyWith(likes: List<Like>.from(post.likes));
    forumPosts.refresh();
    try {
      final response = await ApiService.post('forum/like',
          data: {'id': postId.toString()}, token: DataStroge.accesstoken.value);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          // Success - no need to show message
        } else {
          // Revert
          forumPosts[postIndex] = post.copyWith(likes: originalLikes);
          forumPosts.refresh();
          Get.snackbar("Error", responseData['message'] ?? "Failed to like post.");
        }
      } else {
        forumPosts[postIndex] = post.copyWith(likes: originalLikes);
        forumPosts.refresh();
        Get.snackbar("Error", "Failed to like post.");
      }
    } catch (e) {
      forumPosts[postIndex] = post.copyWith(likes: originalLikes);
      forumPosts.refresh();
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> commentOnPost(int postId, String content) async {
    // Find the post
    final postIndex = forumPosts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;
    final post = forumPosts[postIndex];
    final originalComments = List<Comment>.from(post.comments);
    
    // Optimistic update: add a temporary comment
    final tempComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: DataStroge.currentUser.value!.id,
      postId: postId,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      user: DataStroge.currentUser.value!,
      likes: [],
      replies: [],
    );
    post.comments.add(tempComment);
    forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
    forumPosts.refresh();
    
    try {
      final response = await ApiService.post('forum/comment',data:  {
        'id': postId.toString(),
        'content': content,
      }, token: DataStroge.accesstoken.value);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          // Success - no need to show message
        } else {
          // Revert
          forumPosts[postIndex] = post.copyWith(comments: originalComments);
          forumPosts.refresh();
          Get.snackbar("Error", responseData['message'] ?? "Failed to add comment.");
        }
      } else {
        // Revert
        forumPosts[postIndex] = post.copyWith(comments: originalComments);
        forumPosts.refresh();
        Get.snackbar("Error", "Failed to add comment.");
      }
    } catch (e) {
      // Revert
      forumPosts[postIndex] = post.copyWith(comments: originalComments);
      forumPosts.refresh();
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> likeComment(int commentId) async {
    // Find the comment
    for (var postIndex = 0; postIndex < forumPosts.length; postIndex++) {
      final post = forumPosts[postIndex];
      final commentIndex = post.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = post.comments[commentIndex];
        final currentUserId = DataStroge.currentUser.value!.id;
        final alreadyLiked = comment.likes.any((l) => l.userId == currentUserId);
        final originalLikes = List<Like>.from(comment.likes);
        // Optimistic update
        if (alreadyLiked) {
          comment.likes.removeWhere((l) => l.userId == currentUserId);
        } else {
          comment.likes.add(Like(
            id: DateTime.now().millisecondsSinceEpoch,
            userId: currentUserId,
            likeableType: 'Comment',
            likeableId: commentId,
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          ));
        }
        post.comments[commentIndex] = comment.copyWith(likes: List<Like>.from(comment.likes));
        forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
        forumPosts.refresh();
        try {
          final response = await ApiService.post('forum/comment/like',data:  {'comment_id': commentId.toString()}, token: DataStroge.accesstoken.value);
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            if (responseData['error'] == false) {
              // Success - no need to show message
            } else {
              // Revert
              post.comments[commentIndex] = comment.copyWith(likes: originalLikes);
              forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
              forumPosts.refresh();
              Get.snackbar("Error", responseData['message'] ?? "Failed to like comment.");
            }
          } else {
            post.comments[commentIndex] = comment.copyWith(likes: originalLikes);
            forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
            forumPosts.refresh();
            Get.snackbar("Error", "Failed to like comment.");
          }
        } catch (e) {
          post.comments[commentIndex] = comment.copyWith(likes: originalLikes);
          forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
          forumPosts.refresh();
          Get.snackbar("Error", "An error occurred: $e");
        }
        break;
      }
    }
  }

  Future<void> replyToComment(int commentId, String content) async {
    // Find the comment
    for (var postIndex = 0; postIndex < forumPosts.length; postIndex++) {
      final post = forumPosts[postIndex];
      final commentIndex = post.comments.indexWhere((c) => c.id == commentId);
      if (commentIndex != -1) {
        final comment = post.comments[commentIndex];
        final originalReplies = List<Comment>.from(comment.replies);
        // Optimistic update: add a temporary reply
        final tempReply = Comment(
          id: DateTime.now().millisecondsSinceEpoch,
          userId: DataStroge.currentUser.value!.id,
          postId: post.id,
          content: content,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          user: DataStroge.currentUser.value!,
          likes: [],
          replies: [],
        );
        comment.replies.add(tempReply);
        post.comments[commentIndex] = comment.copyWith(replies: List<Comment>.from(comment.replies));
        forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
        forumPosts.refresh();
        try {
          final response = await ApiService.post('forum/comment/reply',data:  {
            'comment_id': commentId.toString(),
            'content': content,
          }, token: DataStroge.accesstoken.value);
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            if (responseData['error'] == false) {
              // Success - no need to show message
            } else {
              // Revert
              comment.replies = originalReplies;
              post.comments[commentIndex] = comment.copyWith(replies: List<Comment>.from(comment.replies));
              forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
              forumPosts.refresh();
              Get.snackbar("Error", responseData['message'] ?? "Failed to add reply.");
            }
          } else {
            comment.replies = originalReplies;
            post.comments[commentIndex] = comment.copyWith(replies: List<Comment>.from(comment.replies));
            forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
            forumPosts.refresh();
            Get.snackbar("Error", "Failed to add reply.");
          }
        } catch (e) {
          comment.replies = originalReplies;
          post.comments[commentIndex] = comment.copyWith(replies: List<Comment>.from(comment.replies));
          forumPosts[postIndex] = post.copyWith(comments: List<Comment>.from(post.comments));
          forumPosts.refresh();
          Get.snackbar("Error", "An error occurred: $e");
        }
        break;
      }
    }
  }

  // Post a new forum
  Future<bool> postForum() async {
    if (descriptionController.text.isEmpty || imagePath.value.isEmpty || tags.isEmpty) {
      Get.snackbar("Error", "Please provide a description, image, and at least one tag.");
      return false;
    }

    isLoading.value = true;

    try {
      final fields = {
        "caption": descriptionController.text,
      };

      // Add the list of tags to the fields
      for (int i = 0; i < tags.length; i++) {
        fields["tags[$i]"] = tags[i];
      }

      final files = imagePath.value.isNotEmpty ? [File(imagePath.value)] : <File>[];

      final response = await ApiService.postMultiPart(
        'forum',
        fields: fields,
        files: files,
        token: DataStroge.accesstoken.value,
        fileFieldName: "image"
      );

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseData);

        if (jsonResponse['error'] == false) {
          Get.snackbar("Success", jsonResponse['message'] ?? "Forum posted successfully.");
          // Clear form after successful submission
          clearForm();
          return true;
        } else {
          Get.snackbar("Error", jsonResponse['message'] ?? "Failed to post forum.");
          return false;
        }
      } else {
        Get.snackbar("Error", "Failed to post forum. Status Code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editComment(int commentId, String content) async {
    try {
      final response = await ApiService.post('forum/comment/edit', data: {
        'comment_id': commentId.toString(),
        'content': content,
      }, token: DataStroge.accesstoken.value);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (!responseData['error']) {
          Get.snackbar("Success", responseData['message'] ?? "Comment updated successfully.");
          fetchForumPosts();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to update comment.");
        }
      } else {
        Get.snackbar("Error", "Failed to update comment.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      final response = await ApiService.post('forum/comment/delete', data: {
        'comment_id': commentId.toString(),
      }, token: DataStroge.accesstoken.value);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (!responseData['error']) {
          Get.snackbar("Success", responseData['message'] ?? "Comment deleted successfully.");
          fetchForumPosts();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to delete comment.");
        }
      } else {
        Get.snackbar("Error", "Failed to delete comment.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // Clear form after successful submission
  void clearForm() {
    descriptionController.clear();
    imagePath.value = '';
    tags.clear();
  }
}
