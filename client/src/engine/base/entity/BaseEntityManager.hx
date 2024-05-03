package engine.base.entity;

import js.lib.Map;
import engine.base.entity.EngineBaseGameEntity;

// TODO impl base manager
// TODO impl base entity object

class BaseEntityManager {
	public final entities = new js.lib.Map<String, EngineBaseGameEntity>();

	public function destroy() {
		entities.clear();
	}

	public function getChangedEntities() {
		final result = new Array<EngineBaseGameEntity>();
		entities.forEach((value, key, map) -> {
			if (value.isChanged()) {
				result.push(value);
			}
		});
		return result;
	}

	public function add(entity:EngineBaseGameEntity) {
		entities.set(entity.getId(), entity);
	}

	public function remove(id:String) {
		entities.delete(id);
	}

	public function getEntityById(id:String) {
		return entities.get(id);
	}
}
