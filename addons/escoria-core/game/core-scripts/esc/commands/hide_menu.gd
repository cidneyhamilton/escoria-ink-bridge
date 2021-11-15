# `hide_menu main|pause=main [enable_automatic_transition: true|false=false]`
#
# Hides the main or pause menu. 
# The `enable_automatic_transition` is a boolean (default false) can be set 
# to false to disable automatic transitions between scenes, to allow you
# to control your transitions manually using the `transition` command.
#
# @ESC
extends ESCBaseCommand
class_name HideMenuCommand


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		0, 
		[TYPE_STRING, TYPE_BOOL],
		["main", false]
	)


# Validate wether the given arguments match the command descriptor
func validate(arguments: Array):
	if not arguments[0] in ["main", "pause"]:
		escoria.logger.report_errors(
			"hide_menu: invalid menu ",
			[
				"menu %s is invalid" % arguments[0]
			]
		)
		return false
	return .validate(arguments)


# Run the command
func run(command_params: Array) -> int:
	var transition_id: int
	if command_params[1]:
		# Transition out from menu
		transition_id = escoria.main.scene_transition.transition(
			"", 
			ESCTransitionPlayer.TRANSITION_MODE.OUT
		)
		while yield(
			escoria.main.scene_transition, 
			"transition_done"
		) != transition_id:
			pass
		
	if command_params[0] == "main":
		escoria.game_scene.hide_main_menu()
	elif command_params[0] == "pause":
		escoria.game_scene.unpause_game()
		
	if command_params[1] and escoria.main.current_scene != null:
		transition_id = escoria.main.scene_transition.transition()
	
	if command_params[1] and escoria.main.current_scene != null:
		while yield(
			escoria.main.scene_transition, 
			"transition_done"
		) != transition_id:
			pass
	
	return ESCExecution.RC_OK
