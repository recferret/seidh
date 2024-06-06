package game.event;

interface EventListener {
	function notify(event:String, params:Dynamic):Void;
}

class EventManager {

	// Networking events
	public static final EVENT_GAME_INIT = 'EVENT_GAME_INIT';
	public static final EVENT_CREATE_CHARACTER = 'EVENT_CREATE_CHARACTER';
	public static final EVENT_DELETE_CHARACTER = 'EVENT_DELETE_CHARACTER';
	public static final EVENT_GAME_STATE = 'EVENT_GAME_STATE';
	public static final EVENT_CHARACTER_ACTIONS = 'EVENT_CHARACTER_ACTIONS';

	// Internal UI events
	public static final EVENT_HOME_PLAY = 'EVENT_HOME_PLAY';

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
