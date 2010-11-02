function checkUncheckAll(checkAllState, cbGroup)
{
	// Check that the group has more than one element
	if(cbGroup.length > 0)
	{
		// Loop through the array
		for (i = 0; i < cbGroup.length; i++)
		{
			cbGroup[i].checked = checkAllState.checked;
		}
	}
	else
	{
		// Single element so not an array
		cbGroup.checked = checkAllState.checked;
	}
}
