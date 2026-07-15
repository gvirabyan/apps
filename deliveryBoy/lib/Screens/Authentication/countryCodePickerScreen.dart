import 'package:deliveryboy_multivendor/Cubit/loadCountryCodeCubit.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Widget/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryCodePickerScreen extends StatelessWidget {
  CountryCodePickerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    print("isenter screen--->");
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: white,
        appBar: GradientAppBar(
          '',
          customback: false,
        ),
        // appBar: UiUtils.getSimpleAppBar(context: context, title: ''),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 55,
                      child: TextField(
                        onTap: () {},
                        onChanged: (final String text) {
                          context
                              .read<CountryCodeCubit>()
                              .filterCountryCodeList(text);
                        },
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: black,
                        ),
                        // cursorColor: Theme.of(context).colorScheme.onSurface,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsetsDirectional.only(
                              bottom: 2, start: 15),
                          filled: true,
                          fillColor: white,
                          hintText:
                              'SEARCH_COUNTRY'.translate(context: context),
                          hintStyle: TextStyle(color: lightBlack),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: black.withValues(alpha: 0.2)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: black.withValues(alpha: 0.2)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: black.withValues(alpha: 0.2)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Icon(
                              Icons.search,
                              color: lightBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            BlocBuilder<CountryCodeCubit, CountryCodeState>(
              builder:
                  (final BuildContext context, final CountryCodeState state) {
                if (state is CountryCodeLoadingInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is CountryCodeFetchSuccess) {
                  return Expanded(
                    child: state.temporaryCountryList!.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            itemCount: state.temporaryCountryList!.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (final context, final index) {
                              final country =
                                  state.temporaryCountryList![index];
                              return InkWell(
                                onTap: () async {
                                  await Future.delayed(Duration.zero, () {
                                    context
                                        .read<CountryCodeCubit>()
                                        .selectCountryCode(country);

                                    Navigator.pop(context);
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 35,
                                      height: 25,
                                      child: Image.asset(
                                        country.flag,
                                        // fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        country.name,
                                        style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Text(
                                      country.callingCode,
                                      style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (final BuildContext context, final int index) =>
                                    const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                thickness: 0.9,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                                'NO_COUNTRY_FOUND'.translate(context: context)),
                          ),
                  );
                }
                if (state is CountryCodeFetchFail) {
                  return Center(
                      child: Text(
                          state.error.toString().translate(context: context)));
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
