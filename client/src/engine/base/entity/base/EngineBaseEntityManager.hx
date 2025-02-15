package engine.base.entity.base;

import js.lib.Map;

import engine.base.types.TypesBaseEntity;

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

	public function getEntitiesByEntityType(entityType:EntityType) {
		final result = new Array<EngineBaseEntity>();
		entities.forEach((value, key, map) -> {
			if (value.getEntityType() == entityType) {
				result.push(value);
			}
		});
		return result;
	}

	public function add(entity:EngineBaseEntity) {
		entities.set(entity.getId(), entity);
	}

	public function delete(id:String) {
		entities.delete(id);
	}

	public function getEntityById(id:String) {
		return entities.get(id);
	}
}