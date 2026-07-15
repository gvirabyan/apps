import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/deleteGroupCubit.dart';

class DeleteGroupDialog extends StatelessWidget {
  final String groupId;
  const DeleteGroupDialog({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (context.read<DeleteGroupCubit>().state is! DeleteGroupInProgress) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: Text(
            "ARE_YOU_SURE_TO_DELETE_THIS_GROUP".translate(context: context)),
        actions: [
          BlocConsumer<DeleteGroupCubit, DeleteGroupState>(
            listener: (context, state) {
              if (state is DeleteGroupSuccess) {
                Navigator.of(context).pop(true);
              } else if (state is DeleteGroupFailure) {
                Navigator.of(context).pop();
                setSnackbar(state.errorMessage, context);
              }
            },
            builder: (context, state) {
              return state is DeleteGroupInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                            child:
                                Text("LOGOUTYES".translate(context: context)),
                            onPressed: () {
                              context.read<DeleteGroupCubit>().deleteGroup(
                                  groupId: groupId,
                                  currentUserId: context
                                          .read<SettingProvider>()
                                          .CUR_USERID ??
                                      "");
                            }),
                        CupertinoButton(
                            child: Text("LOGOUTNO".translate(context: context)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}
