package game.event;

interface EventListener {
	function notify(event:String, params:Dynamic):Void;
}

class EventManager {

	public static final EVENT_JOIN_GAME = 'EVENT_JOIN_GAME';
	public static final EVENT_CREATE_ENTITY = 'EVENT_CREATE_ENTITY';
	public static final EVENT_DELETE_ENTITY = 'EVENT_DELETE_ENTITY';
	public static final EVENT_GAME_STATE = 'EVENT_GAME_STATE';
	public static final EVENT_PERFORM_ACTION = 'EVENT_PERFORM_ACTION';

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
