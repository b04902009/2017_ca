1. itoa 實作：
	假設要轉換的數字為 i
	t = 4
	while(t--){
		i % 10 + '0'（轉換成 ascii） 存入 output_ascii 對應的 byte 中
		i = i / 10
	}

2. 編寫的平台：Apple