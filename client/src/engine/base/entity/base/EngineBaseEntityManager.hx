package engine.base.entity.base;

import js.lib.Map;

class EngineBaseEntityManager {
	public final entities = new js.lib.Map<String, EngineBaseEntity>();

    public function new() {
    }

	public function destroy() {
		entities.clear();
	}

	public function getChangedEntities() {
		final result = new Array<EngineBaseEntity>();
		entities.forEach((value, key, map) -> {
			if (value.isChanged()) {
				result.push(value);
			}
		});
		return result;
	}

	public function add(entity:EngineBaseEntity) {
		entities.set(entity.getId(), entity);
	}

	public function remove(id:String) {
		entities.delete(id);
	}

	public function getEntityById(id:String) {
		return entities.get(id);
	}
}