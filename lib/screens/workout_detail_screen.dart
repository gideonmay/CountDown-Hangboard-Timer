import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../tabs/edit_grips_tab.dart';
import '../tabs/start_workout_tab.dart';
import '../widgets/helper_dialog.dart';
import 'add_grip_screen.dart';

/// A screen that displays the details of a workout and allows the user to
/// add, edit, and organize grips for their workout
class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();

  /// Navigates to the AddGripScreen widget
  static _navigateToAddGrip(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddGripScreen(workout: workout)),
    );
  }
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen>
    with TickerProviderStateMixin {
  final List<Tab> _tabs = [
    const Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.info),
          ),
          Text('Details')
        ],
      ),
    ),
    const Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Icon(Icons.edit_outlined),
          ),
          Text('Edit Grips')
        ],
      ),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_updateIndex);
  }

  void _updateIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: _actions(context),
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        StartWorkoutTab(workout: widget.workout),
        EditGripsTab(workout: widget.workout),
      ]),
    );
  }

  /// Returns a button that navigates to the AddGripScreen only if the current
  /// tab is set to index 1, which is the Edit Grips tab
  List<Widget> _actions(BuildContext context) {
    if (_tabController.index == 1) {
      return [
        IconButton(
            onPressed: () =>
                WorkoutDetailScreen._navigateToAddGrip(context, widget.workout),
            icon: const Icon(Icons.add))
      ];
    }

    return [];
  }

  // TODO: Only show when user first visits this screen
  Future<String?> _showHelperDialog(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => HelperDialog(
            title: 'Editing Grips',
            body:
                'To edit the order of a grip, tap and hold the grip then drag it to the desired position. Alternatively, move the grip using the drag handle on the right.',
            image: Image.asset('assets/gifs/grip_sequence_demo.gif')));
  }
}
