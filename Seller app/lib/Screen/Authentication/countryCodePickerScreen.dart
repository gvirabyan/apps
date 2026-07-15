import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Widget/appBar.dart';
import 'package:sellermultivendor/cubits/loadCountryCodeCubit.dart';

class CountryCodePickerScreen extends StatelessWidget {
  const CountryCodePickerScreen({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: white,
        appBar: const GradientAppBar(
          '',
        ),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsetsDirectional.only(
                              bottom: 2, start: 15),
                          filled: true,
                          fillColor: white,
                          hintText:
                              'SEARCH_COUNTRY'.translate(context: context),
                          hintStyle: const TextStyle(color: lightBlack),
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
                            child: const Icon(
                              Icons.search,
                              color: lightBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
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
                                        style: const TextStyle(
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
                                      style: const TextStyle(
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
