package engine.base.entity;

abstract class EngineProjectileEntity {
	
	private final ownerId:String;
	private final x:Float;
	private final y:Float;
	private final r:Float;
	private final speed:Float;
	private final aoeSize:Int;
	private final travelDistance:Float;

	private var allowMovement = true;
	private var traveledDistance = 0.0;

	// TODO pass full config as an object
	public function new(ownerId:String, x:Float, y:Float, r:Float, speed:Float, aoeSize:Int, travelDistance:Float) {
		this.ownerId = ownerId;
		this.x = x;
		this.y = y;
		this.r = r;
		this.speed = speed;
		this.aoeSize = aoeSize;
		this.travelDistance = travelDistance;
	}

	// TODO update interface
	public function update(dt:Float) {
		if (allowMovement) {
			final dx = speed * Math.cos(r) * dt;
			final dy = speed * Math.sin(r) * dt;
	
			traveledDistance += (dx + dy);
	
			if (traveledDistance > travelDistance) {
				allowMovement = false;
			}
		}
		// currentDirectionSide = (baseObjectEntity.x + dx) > baseObjectEntity.x ? Side.RIGHT : Side.LEFT;

		// baseObjectEntity.x += Std.int(dx);
		// baseObjectEntity.y += Std.int(dy);
	}

}
