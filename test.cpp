#include <cassert>
#include <iostream>
#include "dsm_db.h"

using std::string;
using std::cout;

int
main (int argc, char *argv[])
{
	dsm_db db1;
	string dbname, key, value;

	dbname = "dsm.db1";
	key = "dsm";
	value = "666";
	db1.open(dbname);

	db1.put(key, value);

	value.clear();
	db1.get(key, &value);
	cout << value.length() << ": " << value << '\n';

	db1.del(key);
	value.clear();
	db1.get(key, &value);
	cout << value.length() << ": " << value << '\n';
}
