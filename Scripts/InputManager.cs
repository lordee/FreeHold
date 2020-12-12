using Godot;
using System;
using System.Collections.Generic;

public class InputManager : Node
{
    static List<BindingObject> Binds = new List<BindingObject>();
	InputCommand cmd = new InputCommand();
	static InputManager that;
   
    public override void _Ready()
    {
		that = this;
    }

	public override void _Input(InputEvent @event)
    {
		foreach (BindingObject b in Binds)
        {
			if (b.Type == ButtonInfo.TYPE.MOUSEBUTTON)
			{
				if (Input.IsActionJustPressed(b.Name))
				{
					b.Method.Invoke(1);
				}
				if (Input.IsActionJustReleased(b.Name))
				{
					b.Method.Invoke(-1);
				}
			}
		}
    }

    public override void _PhysicsProcess(float delta)
    {
        foreach (BindingObject b in Binds)
        {
			switch (b.Type)
			{
				case ButtonInfo.TYPE.SCANCODE:
					if (Input.IsActionJustPressed(b.Name))
					{
						b.Method.Invoke(1);
					}
					if (Input.IsActionJustReleased(b.Name))
					{
						b.Method.Invoke(-1);
					}
					break;
			}
        }

		RtsCameraController.InputCommands.Add(cmd);
		
		cmd.ZoomDirection = 0;
		cmd.IsPanning = 0;
		cmd.IsRotating = 0;
		cmd.ClickLeft = cmd.ClickLeft == -1 ? 0 : cmd.ClickLeft;
		cmd.ClickRight = cmd.ClickRight == -1 ? 0 : cmd.ClickRight;
		cmd.BuildingRotate = 0;
    }

    static public void Bind(string a, string k, Action<float> method)
    {
        string action = a.ToLower();
        string key = k.ToLower();

        BindingObject b = new BindingObject(action, key, method);

        KeyType kt = null;
        KeyTypes.List.TryGetValue(key, out kt);
        // scancodes
        uint Scancode = 0;
        var ButtonValue = ButtonList.Left;
		var AxisDirection = ButtonInfo.DIRECTION.UP;
		var ControllerButtonValue = JoystickList.Axis0;

        if (kt == null)
        {
            uint LocalScancode = (uint)OS.FindScancodeFromString(key);
            if(LocalScancode != 0)
            {
                //Is a valid Scancode
                Scancode = LocalScancode;
				b.Type = ButtonInfo.TYPE.SCANCODE;
            }
            else if (key == "`") // this fails on ubuntu 18.04 (scancode of 0 given back)
            {
                Scancode = 96;
				b.Type = ButtonInfo.TYPE.SCANCODE;
            }
            else
            {
                throw new NotImplementedException("Bind of key " + key + " is not valid");
            }
        }
        else
        {
            b.Type = kt.Type;
            ButtonValue = kt.ButtonValue;
			AxisDirection = kt.Direction;
			ControllerButtonValue = kt.ControllerButtonValue;
        }

        if (!InputMap.HasAction(action))
        {
            InputMap.AddAction(action);
        }

        switch(b.Type)
		{
			case(ButtonInfo.TYPE.SCANCODE): {
				InputEventKey Event = new InputEventKey {Scancode = Scancode};
				InputMap.ActionAddEvent(action, Event);
				break;
			}

			case(ButtonInfo.TYPE.MOUSEBUTTON):
			case(ButtonInfo.TYPE.MOUSEWHEEL): {
				InputEventMouseButton Event = new InputEventMouseButton {
					ButtonIndex = (int)ButtonValue
				};
				InputMap.ActionAddEvent(action, Event);
				break;
			}

			case(ButtonInfo.TYPE.MOUSEAXIS): {
				InputEventMouseMotion Event = new InputEventMouseMotion();
				InputMap.ActionAddEvent(action, Event);
				b.AxisDirection = (ButtonInfo.DIRECTION)AxisDirection; //Has to cast as it is Nullable
				break;
			}

			case(ButtonInfo.TYPE.CONTROLLERAXIS): {
				InputEventJoypadMotion Event = new InputEventJoypadMotion {
					Axis = (int)ControllerButtonValue
				};
				// Set which Joystick axis we're using
				switch (AxisDirection) { // Set which direction on the axis we need to trigger the event
					case(ButtonInfo.DIRECTION.UP): {
						Event.AxisValue = -1; // -1, on the Vertical axis is up
						break;
					}

					case(ButtonInfo.DIRECTION.LEFT): {
						Event.AxisValue = -1; // -1, on the Horizontal axis is left
						break;
					}

					case(ButtonInfo.DIRECTION.DOWN): {
						Event.AxisValue = 1; // 1, on the Vertical axis is down
						break;
					}

					case(ButtonInfo.DIRECTION.RIGHT): {
						Event.AxisValue = 1; // 1, on the Horizontal axis is right
						break;
					}
				}

				InputMap.ActionAddEvent(action, Event);
				b.AxisDirection = (ButtonInfo.DIRECTION)AxisDirection; //Has to cast as it is Nullable
				break;
			}

			case(ButtonInfo.TYPE.CONTROLLERBUTTON): {
				InputEventJoypadButton Event = new InputEventJoypadButton {
					ButtonIndex = (int) ControllerButtonValue
				};
				InputMap.ActionAddEvent(action, Event);
				break;
			}
		}
        Binds.Add(b);
    }

	static public void BuildingRotate(float val)
	{
		that.cmd.BuildingRotate = 1;
	}

	static public void CameraZoomIn(float val)
	{
		that.cmd.ZoomDirection = -1;
	}

	static public void CameraZoomOut(float val)
	{
		that.cmd.ZoomDirection = 1;
	}

	static public void CameraRotate(float val)
	{
		that.cmd.IsRotating = val;
	}

	static public void CameraPan(float val)
	{
		that.cmd.IsPanning = val;
	}

	static public void CameraForward(float val)
	{
		that.cmd.MoveForward = val == 1 ? 1 : 0;
	}

	static public void CameraBackward(float val)
	{
		that.cmd.MoveForward = val == 1 ? -1 : 0;
	}

	static public void CameraRight(float val)
	{
		that.cmd.MoveLeft = val == 1 ? -1 : 0;
	}

	static public void CameraLeft(float val)
	{
		that.cmd.MoveLeft = val == 1 ? 1 : 0;
	}

	static public void ClickLeft(float val)
	{
		that.cmd.ClickLeft = val;
	}

	static public void ClickRight(float val)
	{
		that.cmd.ClickRight = val;
	}
}
