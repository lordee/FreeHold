using System;
using System.Collections.Generic;


public class BindingObject
{
	public string Name = null; //Null to fail early
	public string Key = null;
	public ButtonInfo.TYPE Type = ButtonInfo.TYPE.UNSET;
	public ButtonInfo.DIRECTION AxisDirection; //Only used if Type is AXIS

	public Action<float> Method;

	public bool JoyWasInDeadzone = true;

	public BindingObject(string name, string key, Action<float> method)
	{
		Name = name;
		Key = key;
		Method = method;
	}

	public bool Equals(BindingObject Other)
	{
		return Name == Other.Name;
	}
}
