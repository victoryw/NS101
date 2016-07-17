Function Merge-Hashtable($target, $source) {
  $result = @{}

  $target.GetEnumerator() | % {
      if($_.value -ne $null) {
          $result[$_.key] = $_.value
      }
   }
    
	$source.GetEnumerator() | % {
		if($_.value -ne $null) {
  			$result[$_.key] = $_.value
  		}
	}

	$result
}
