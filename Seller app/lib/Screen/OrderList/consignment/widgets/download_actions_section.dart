import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/generateAWBRepository.dart';
import 'package:sellermultivendor/Repository/sendPickUpRequestRepository.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignment_invoice.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignment_label.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/generate_awb_cubit.dart';
import 'package:sellermultivendor/cubits/order/send_pickup_request_cubit.dart';
import 'package:http/http.dart' as http;

/// Section containing all download actions (AWB, Pickup Request, Label, Invoice)
class DownloadActionsSection extends StatelessWidget {
  final ConsignmentModel consignment;

  const DownloadActionsSection({
    super.key,
    required this.consignment,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => GenerateAWBCubit(GenerateAWBRepository())),
        BlocProvider(
            create: (context) =>
                SendPickUpRequestCubit(SendPickUpRepository())),
        BlocProvider(create: (context) => FetchConsignmentLabelCubit()),
        BlocProvider(create: (context) => FetchConsignmentInvoiceCubit()),
      ],
      child: _DownloadActionsSectionContent(consignment: consignment),
    );
  }
}

/// Internal widget containing the actual download actions UI
class _DownloadActionsSectionContent extends StatefulWidget {
  final ConsignmentModel consignment;

  const _DownloadActionsSectionContent({
    required this.consignment,
  });

  @override
  State<_DownloadActionsSectionContent> createState() =>
      _DownloadActionsSectionContentState();
}

class _DownloadActionsSectionContentState
    extends State<_DownloadActionsSectionContent> {
  Future<bool> checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Generate AWB Section
        if (widget.consignment.isShiprocketOrderCreatedBool) ...[
          if ((widget.consignment.trackingDetails!.awbCode == "" ||
                  widget.consignment.trackingDetails!.awbCode == null) &&
              widget.consignment.activeStatus.toString().toLowerCase() !=
                  'canceled')
            _buildGenerateAWBSection(),

          // Send Pickup Request Section
          if (widget.consignment.trackingDetails!.pickupScheduledDate == "" &&
              (widget.consignment.activeStatus.toString().toLowerCase() !=
                      'canceled' ||
                  widget.consignment.activeStatus.toString().toLowerCase() !=
                      'pickup scheduled' ||
                  widget.consignment.activeStatus.toString().toLowerCase() !=
                      'cancellation requested'))
            _buildSendPickupRequestSection(),

          // Download Label Section
          if (widget.consignment.trackingDetails!.labelUrl != "")
            _buildDownloadLabelSection(),

          const SizedBox(height: 5),
        ],

        // Download Invoice Section
        _buildDownloadInvoiceSection(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildGenerateAWBSection() {
    return BlocConsumer<GenerateAWBCubit, GenerateAWBState>(
      listener: (context, state) {
        if (state is GenerateAWBSuccess) {
          context
              .read<FetchConsignmentsCubit>()
              .updateConsignment(state.result);
          setState(() {});
          setSnackbar(
            'SEND_SUCCESS'.translate(context: context),
            context,
            backgroundColor: Colors.green,
          );
        }

        if (state is GenerateAWBFailure) {
          setSnackbar(
            state.errorMessage,
            context,
            backgroundColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Card(
              elevation: 0,
              child: InkWell(
                child: ListTile(
                  dense: true,
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                    color: primary,
                  ),
                  leading: const Icon(
                    Icons.sim_card_download_outlined,
                    color: primary,
                  ),
                  title: Text(
                    'GENERATE_AWB'.translate(context: context),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: black),
                  ),
                ),
                onTap: () async {
                  context.read<GenerateAWBCubit>().generateAWB(
                        shipmentId:
                            widget.consignment.trackingDetails!.shipmentId!,
                      );
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }

  Widget _buildSendPickupRequestSection() {
    return BlocConsumer<SendPickUpRequestCubit, SendPickUpRequestState>(
      listener: (context, state) {
        if (state is SendPickUpRequestSuccess) {
          context
              .read<FetchConsignmentsCubit>()
              .updateConsignment(state.result);
          setState(() {});

          setSnackbar(
            'SEND_SUCCESS'.translate(context: context),
            context,
            backgroundColor: Colors.green,
          );
        }

        if (state is SendPickUpRequestFailure) {
          setSnackbar(
            state.errorMessage,
            context,
            backgroundColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Card(
              elevation: 0,
              child: InkWell(
                child: ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.send_sharp,
                    color: primary,
                  ),
                  title: Text(
                    'SENDPICKUPREQUEST'.translate(context: context),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: black),
                  ),
                ),
                onTap: () async {
                  context.read<SendPickUpRequestCubit>().sendRequest(
                        shipmentId:
                            widget.consignment.trackingDetails!.shipmentId!,
                      );

                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }

  Widget _buildDownloadLabelSection() {
    return BlocConsumer<FetchConsignmentLabelCubit, FetchConsignmentLabelState>(
      listener: (context, state) async {
        if (state is FetchConsignmentLabelFailure) {
          setSnackbar(state.error, context);
        }
        if (state is FetchConsignmentLabelSuccess) {
          String pdfUrl = state.consignmentLabel;

          if (pdfUrl.trim().isNotEmpty) {
            bool hasPermission = await checkPermission();

            String target = Platform.isAndroid && hasPermission
                ? (await ExternalPath.getExternalStoragePublicDirectory(
                    ExternalPath.DIRECTORY_DOWNLOAD,
                  ))
                : (await getApplicationDocumentsDirectory()).path;

            var targetFileName = 'Label_${widget.consignment.name}.pdf';
            var filePath = '$target/$targetFileName';

            try {
              var response = await http.get(Uri.parse(pdfUrl));
              if (response.statusCode == 200) {
                File file = File(filePath);
                await file.writeAsBytes(response.bodyBytes);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "${'LABEL_PATH'.translate(context: context)} $targetFileName",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: black),
                    ),
                    action: SnackBarAction(
                      label: 'VIEW'.translate(context: context),
                      textColor: black,
                      onPressed: () async {
                        await OpenFile.open(filePath);
                      },
                    ),
                    backgroundColor: white,
                    elevation: 1.0,
                  ),
                );
              } else {
                setSnackbar(
                    'somethingMSg'.translate(context: context), context);
              }
            } catch (e) {
              setSnackbar('somethingMSg'.translate(context: context), context);
              return;
            }
          } else {
            setSnackbar('somethingMSg'.translate(context: context), context);
          }
        }
      },
      builder: (context, state) {
        return Card(
          elevation: 0,
          child: InkWell(
            child: ListTile(
              dense: true,
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: primary,
              ),
              leading: const Icon(
                Icons.receipt,
                color: primary,
              ),
              title: Text(
                'Download Label'.translate(context: context),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: black),
              ),
            ),
            onTap: () async {
              context.read<FetchConsignmentLabelCubit>().fetchConsignmentLabel(
                  widget.consignment.trackingDetails!.shipmentId!);
            },
          ),
        );
      },
    );
  }

  Widget _buildDownloadInvoiceSection() {
    return BlocConsumer<FetchConsignmentInvoiceCubit,
        FetchConsignmentInvoiceState>(
      listener: (context, state) async {
        if (state is FetchConsignmentInvoiceFailure) {
          setSnackbar(state.error, context);
        }
        if (state is FetchConsignmentInvoiceSuccess) {
          String invoiceHtml = state.consignmentInvoice;
          if (invoiceHtml.trim().isNotEmpty) {
            bool hasPermission = await checkPermission();

            String target = Platform.isAndroid && hasPermission
                ? (await ExternalPath.getExternalStoragePublicDirectory(
                    ExternalPath.DIRECTORY_DOWNLOAD,
                  ))
                : (await getApplicationDocumentsDirectory()).path;

            var targetFileName = 'Invoice_${widget.consignment.name}';
            var generatedPdfFile, filePath;
            try {
              generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
                  invoiceHtml, target, targetFileName);
              filePath = generatedPdfFile.path;
            } catch (e) {
              setSnackbar('somethingMSg'.translate(context: context), context);
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${'INVOICE_PATH'.translate(context: context)} $targetFileName",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: black),
                ),
                action: SnackBarAction(
                  label: 'VIEW'.translate(context: context),
                  textColor: black,
                  onPressed: () async {
                    await OpenFile.open(filePath);
                  },
                ),
                backgroundColor: white,
                elevation: 1.0,
              ),
            );
          } else {
            setSnackbar('somethingMSg'.translate(context: context), context);
          }
        }
      },
      builder: (context, state) {
        return Card(
          elevation: 0,
          child: InkWell(
            child: ListTile(
              dense: true,
              trailing: const Icon(
                Icons.keyboard_arrow_right,
                color: primary,
              ),
              leading: const Icon(
                Icons.receipt,
                color: primary,
              ),
              title: Text(
                'Download Invoice'.translate(context: context),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: black),
              ),
            ),
            onTap: () async {
              context
                  .read<FetchConsignmentInvoiceCubit>()
                  .fetchConsignmentInvoice(widget.consignment.id);
            },
          ),
        );
      },
    );
  }
}
