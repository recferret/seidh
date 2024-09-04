package game.event;

interface EventListener {
	function notify(event:String, params:Dynamic):Void;
}

class EventManager {

	// Networking events

	// Game
	public static final EVENT_GAME_INIT = 'GameInit';
	public static final EVENT_LOOP_STATE = 'LoopState';
	public static final EVENT_GAME_STATE = 'GameState';
	public static final EVENT_CREATE_CHARACTER = 'CreateCharacter';
	public static final EVENT_DELETE_CHARACTER = 'DeleteCharacter';
	public static final EVENT_CREATE_CONSUMABLE = 'CreateConsumable';
	public static final EVENT_DELETE_CONSUMABLE = 'DeleteConsumable';
	public static final EVENT_CHARACTER_ACTIONS = 'CharacterActions';

	// User
	public static final EVENT_USER_BALANCE = 'UserBalance';

	// Internal events
	public static final EVENT_HOME_PLAY = 'EVENT_HOME_PLAY';
	public static final EVENT_HOME_SCENE = 'EVENT_HOME_SCENE';
	public static final EVENT_REF_SHARE = 'EVENT_REF_SHARE';

	private final listeners = new Map<String, List<EventListener>>();

	public static final instance:EventManager = new EventManager();

	private function new() {}

	public function subscribe(eventType:String, listener:EventListener) {
		if (listeners.exists(eventType)) {
			final users = listeners.get(eventType);
			users.add(listener);
		} else {
			final newList = new List();
			newList.add(listener);
			listeners.set(eventType, newList);
		}
	}

	public function unsubscribe(eventType:String, listener:EventListener) {
		final users = listeners.get(eventType);
		users.remove(listener);
	}

	public function notify(eventType:String, params:Dynamic) {
		final ls = listeners.get(eventType);
		for (listener in ls) {
			listener.notify(eventType, params);
		}
	}
}
