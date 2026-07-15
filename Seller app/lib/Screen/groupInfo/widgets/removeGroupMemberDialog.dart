import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/groupDetails.dart';
import 'package:sellermultivendor/Model/groupMEmber.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/removeGroupMemberCubit.dart';

class RemoveGroupMemberDialog extends StatelessWidget {
  final GroupDetails groupDetails;
  final GroupMember groupMember;
  const RemoveGroupMemberDialog(
      {super.key, required this.groupMember, required this.groupDetails});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (context.read<RemoveGroupMemberCubit>().state
            is! RemoveGroupMemberInProgress) {
          if (didPop) {
            return;
          }
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: Text(
            "ARE_YOU_SURE_TO_REMOVE_THIS_MEMBER".translate(context: context)),
        actions: [
          BlocConsumer<RemoveGroupMemberCubit, RemoveGroupMemberState>(
            listener: (context, state) {
              if (state is RemoveGroupMemberSuccess) {
                Navigator.of(context).pop(state.groupDetails);
              } else if (state is RemoveGroupMemberFailure) {
                Navigator.of(context).pop();
                setSnackbar(state.errorMessage, context);
              }
            },
            builder: (context, state) {
              return state is RemoveGroupMemberInProgress
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
                              List<String> userIds = groupDetails.groupMembers!
                                  .map((e) => e.userId!)
                                  .toList();
                              userIds.removeWhere(
                                  (element) => element == groupMember.userId);

                              context.read<RemoveGroupMemberCubit>().editGroup(
                                  title: groupDetails.title!,
                                  groupId: groupDetails.groupId!,
                                  description: groupDetails.description!,
                                  userIds: userIds,
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
