/// Stores the name and description of a workout. Used as a data transfer object
/// between certain widget and the form widgets that facilitate creating and
/// updating workouts.
class WorkoutDTO {
  String? name;
  String? description;

  WorkoutDTO({required this.name, required this.description});

  /// Creates an object with blank name and description fields
  WorkoutDTO.blank() : name = "", description = "";
}