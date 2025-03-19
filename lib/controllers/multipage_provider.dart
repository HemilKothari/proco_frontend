import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:im_stepper/stepper.dart';
import 'package:jobhub_v1/models/multipage_model.dart';
//import 'package:multi_step_form/modal/user_modal.dart';
import 'package:provider/provider.dart';

class MultiPageProvider extends StatefulWidget {
  const MultiPageProvider({Key? key}) : super(key: key);

  @override
  _MultiPageProviderState createState() => _MultiPageProviderState();
}

class _MultiPageProviderState extends State<MultiPageProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModal>(
      create: (context) => UserModal(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Using Provider",
          ),
        ),
        body: Consumer<UserModal>(
          builder: (context, modal, child) {
            switch (modal.activeIndex) {
              case 0:
                return const BasicDetails();
              case 1:
                return const EducationDetails();

              default:
                return const BasicDetails();
            }
          },
        ),
      ),
    );
  }
}

class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key}) : super(key: key);

  @override
  _BasicDetailsState createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return Form(
        key: basicFormKey,
        child: ListView(
          padding: const EdgeInsets.all(
            12.0,
          ),
          children: [
            Center(
              child: DotStepper(
                activeStep: modal.activeIndex,
                dotRadius: 20.0,
                shape: Shape.pipe,
                spacing: 10.0,
              ),
            ),
            Text(
              "Step ${modal.activeIndex + 1} of ${modal.totalIndex}",
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Name",
              ),
              validator: RequiredValidator(
                errorText: "Required *",
              ),
            ),
            TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                validator: MultiValidator([
                  RequiredValidator(
                    errorText: "Required *",
                  ),
                  EmailValidator(
                    errorText: "Not Valid Email",
                  ),
                ])),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Passoword",
              ),
              validator: MinLengthValidator(
                6,
                errorText: "Min 6 characters required",
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SizedBox(
              height: 40.0,
              child: ElevatedButton(
                onPressed: () {
                  if (basicFormKey.currentState?.validate() ?? false) {
                    // next
                    modal.changeStep(1);
                  }
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class EducationDetails extends StatelessWidget {
  const EducationDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModal>(builder: (context, modal, child) {
      return ListView(
        padding: const EdgeInsets.all(
          12.0,
        ),
        children: [
          Center(
            child: DotStepper(
              activeStep: modal.activeIndex,
              dotRadius: 20.0,
              shape: Shape.pipe,
              spacing: 10.0,
            ),
          ),
          Text(
            "Step ${modal.activeIndex + 1} of ${modal.totalIndex}",
            style: const TextStyle(
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Name",
            ),
            validator: RequiredValidator(
              errorText: "Required *",
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          SizedBox(
            height: 40.0,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
