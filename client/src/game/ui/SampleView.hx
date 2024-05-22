package game.ui;

@:uiComp("view")
class ViewComp extends h2d.Flow implements h2d.domkit.Object {

	static var SRC =
	<view class="mybox" min-width="200" content-halign={align}>
		<text text={"Hello World"}/>
		for( i in icons )
			<bitmap src={i} id="icons[]"/>
	</view>;

	public function new(align:h2d.Flow.FlowAlign,icons:Array<h2d.Tile>,?parent) {
		super(parent);
		initComponent();
	}

}

@:uiComp("button")
class ButtonComp extends h2d.Flow implements h2d.domkit.Object {

	static var SRC = <button>
		<text public id="labelTxt" />
	</button>

	public var label(get, set): String;
	function get_label() return labelTxt.text;
	function set_label(s) {
		labelTxt.text = s;
		return s;
	}

	public function new( ?parent ) {
		super(parent);
		initComponent();
		enableInteractive = true;
		interactive.onClick = function(_) onClick();
		interactive.onOver = function(_) {
			dom.hover = true;
		};
		interactive.onPush = function(_) {
			dom.active = true;
		};
		interactive.onRelease = function(_) {
			dom.active = false;
		};
		interactive.onOut = function(_) {
			dom.hover = false;
		};
	}

	public dynamic function onClick() {
	}
}

@:uiComp("container")
class ContainerComp extends h2d.Flow implements h2d.domkit.Object {

	static var SRC = <container>
		<view(align,[]) id="view"/>
		<button public id="btn"/>
		<button public id="btn1"/>
		<button public id="btn2"/>
	</container>;

	public function new(align:h2d.Flow.FlowAlign, ?parent) {
		super(parent);
		initComponent();
	}

}