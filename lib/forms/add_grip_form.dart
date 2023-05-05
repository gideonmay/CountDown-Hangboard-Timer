import 'package:countdown_app/extensions/string_casing_extension.dart';
import 'package:countdown_app/models/grip_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../screens/add_grip_type_screen.dart';

/// A form that allows user to input grip information
class AddGripForm extends StatefulWidget {
  final GripDTO gripDTO;

  const AddGripForm({super.key, required this.gripDTO});

  @override
  State<AddGripForm> createState() => _AddGripFormState();
}

class _AddGripFormState extends State<AddGripForm> {
  final _formKey = GlobalKey<FormState>();

  final List<Map> gripTypes = [
    {'id': 1, 'name': 'full crimp'},
    {'id': 2, 'name': 'half crimp'}
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text('Grip Details',
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
            ),
            _gripTypeDropdown(),
            _setsSpinBox(),
            _repsSpinBox(),
            _workSpinBox(),
            _restSpinBox(),
            _breakSpinBoxes(),
            const Divider(thickness: 1.0, indent: 5.0, endIndent: 5.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text('Post-Grip Break',
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                  'Specify the break duration between this grip and the next'),
            ),
            _lastBreakSpinBoxes(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {},
                  child:
                      const Text('Submit', style: TextStyle(fontSize: 20.0))),
            ),
          ],
        ),
      ),
    );
  }

  /// Dropdown menu that allows user to choose the grip type
  Widget _gripTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 75,
            child: _buildDropdownFormField(context),
          ),
          Flexible(
              flex: 25,
              child: Center(
                child: ElevatedButton(
                    onPressed: () => _navigateToAddGripType(context),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        fixedSize: const Size(50, 50)),
                    child: const Icon(Icons.add)),
              )),
        ],
      ),
    );
  }

  /// Returns a List of DropdownMenuItems for each grip type in the database
  StreamBuilder<List<GripType>> _buildDropdownFormField(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: db.watchAllGripTypes(),
      builder: (context, AsyncSnapshot<List<GripType>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final gripTypes = snapshot.data ?? List.empty();

        return DropdownButtonFormField(
          value: widget.gripDTO.gripTypeID,
          hint: const Text('Choose a grip type'),
          items: gripTypes.map((GripType gripType) {
            return DropdownMenuItem(
                value: gripType.id, child: Text(gripType.name.toTitleCase()));
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please choose a grip type';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              widget.gripDTO.gripTypeID = value as int;
            });
          },
          onSaved: (value) {
            setState(() {
              widget.gripDTO.gripTypeID = value as int;
            });
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: TextStyle(fontSize: 24.0)),
        );
      },
    );
  }

  /// Navigates to the AddGripType widget
  static _navigateToAddGripType(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddGripTypeScreen()),
    );
  }

  /// Spin box that allow user to choose number of sets
  Widget _setsSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.sets,
        min: 1,
        max: 20,
        onChanged: (value) {
          setState(() {
            // Do not allow value of zero or lower
            if (value <= 0) {
              widget.gripDTO.sets = 1;
            } else {
              widget.gripDTO.sets = value;
            }
          });
        },
        decoration: const InputDecoration(
            labelText: 'Sets', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin box that allow user to choose number of sets
  Widget _repsSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.reps,
        min: 1,
        max: 20,
        onChanged: (value) {
          setState(() {
            // Do not allow value of zero or lower
            if (value <= 0) {
              widget.gripDTO.reps = 1;
            } else {
              widget.gripDTO.reps = value;
            }
          });
        },
        decoration: const InputDecoration(
            labelText: 'Reps', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin box that allow user to choose work seconds
  Widget _workSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.workSeconds,
        min: 1,
        max: 60,
        onChanged: (value) {
          setState(() {
            widget.gripDTO.workSeconds = value;
          });
        },
        decoration: const InputDecoration(
            labelText: 'Work (sec)', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin box that allow user to choose rest seconds
  Widget _restSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.restSeconds,
        min: 1,
        max: 60,
        onChanged: (value) {
          setState(() {
            widget.gripDTO.restSeconds = value;
          });
        },
        decoration: const InputDecoration(
            labelText: 'Rest (sec)', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin boxes that allow user to choose break minutes and seconds
  Widget _breakSpinBoxes() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: SpinBox(
              value: widget.gripDTO.breakMinutes,
              min: 0,
              max: 30,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.breakMinutes = value;
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Break (min)',
                  labelStyle: TextStyle(fontSize: 24.0)),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
            child: SpinBox(
              value: widget.gripDTO.breakSeconds,
              min: 0,
              max: 60,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.breakSeconds = value;
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Break (sec)',
                  labelStyle: TextStyle(fontSize: 24.0)),
            ),
          ),
        ),
      ],
    );
  }

  /// Spin boxes that allow user to choose break minutes and seconds that occur
  /// after the last rep for the current grip
  Widget _lastBreakSpinBoxes() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: SpinBox(
              value: widget.gripDTO.lastBreakMinutes,
              min: 0,
              max: 30,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.lastBreakMinutes = value;
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Break (min)',
                  labelStyle: TextStyle(fontSize: 24.0)),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
            child: SpinBox(
              value: widget.gripDTO.lastBreakSeconds,
              min: 0,
              max: 60,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.lastBreakSeconds = value;
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Break (sec)',
                  labelStyle: TextStyle(fontSize: 24.0)),
            ),
          ),
        ),
      ],
    );
  }
}
