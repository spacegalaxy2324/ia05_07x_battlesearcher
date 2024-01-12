import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class Avatar extends StatefulWidget {
  Avatar({
    super.key,
    this.imageUrl,
    required this.onUpload,
    this.buttonUpload = false,
    this.size = 150.0,
  });

  String? imageUrl;
  final void Function(String) onUpload;
  final bool? buttonUpload;
  final double? size;

  @override
  // ignore: library_private_types_in_public_api
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;
  String imageUrlResponse = "";
  SupabaseClient client = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // ignore: unused_local_variable
    Future<String> fetchImage = getImageFromUser().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          widget.imageUrl = value;
        });
      });
      return "";
    });
  }

  Future<String> getImageFromUser() async {
    List<dynamic> res = await client
        .from("profiles")
        .select()
        .match({"id": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;

    return user["avatar_url"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Stack(
              fit: StackFit.loose, // Just Changed this line
              alignment: Alignment.bottomRight, // Just changed this line
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Theme.of(context).colorScheme.primary
                  ),
                  width: widget.size,
                  height: widget.size,
                  child: Center(
                      child: Icon(
                    Icons.person,
                    size: widget.size,
                    color: Theme.of(context).colorScheme.primary,
                  )),
                ),
                if (widget.buttonUpload == true)
                  IconButton.filled(
                    onPressed: _isLoading ? null : _upload,
                    icon: const Icon(Icons.add_a_photo_outlined),
                  ),
              ])
        else
          Stack(
              fit: StackFit.loose, // Just Changed this line
              alignment: Alignment.bottomRight, // Just changed this line
              children: [
                Container(
                  width: widget.size,
                  height: widget.size,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    widget.imageUrl!,
                    width: widget.size,
                    height: widget.size,
                    fit: BoxFit.cover,
                  ),
                ),
                if (widget.buttonUpload == true)
                  IconButton.filled(
                    onPressed: _isLoading ? null : _upload,
                    icon: const Icon(Icons.add_a_photo_outlined),
                  ),
              ]),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await client.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      imageUrlResponse = await client.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      await client.from('profiles').upsert({
        'id': client.auth.currentUser!.id,
        'avatar_url': imageUrlResponse,
      });
    } on StorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    setState(() {
      widget.imageUrl = imageUrlResponse;
      //print(widget.imageUrl);
      _isLoading = false;
    });
  }
}
