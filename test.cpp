#include <cassert>
#include <iostream>
#include "leveldb/db.h"
//#include <leveldb/db.h>

using ldb = leveldb::DB;
using ldb_opt = leveldb::Options;
using ldb_sta = leveldb::Status;
using ldb_opt_r = leveldb::ReadOptions;
using ldb_opt_w = leveldb::WriteOptions;
using std::string;
using std::cout;

class dsm_db
{
	ldb *db;
	ldb_opt opt;
	ldb_sta fake;
	ldb_opt_r opt_r;
	ldb_opt_w opt_w;
  public:
	dsm_db();
	void
	open(string);
	int
	put(string, string);
	int
	get(string, string *);
	int
	del(string);
};

dsm_db::dsm_db()
{
	db = nullptr;
	opt.create_if_missing = true;
}

void
dsm_db::open(string name)
{
	fake = ldb::Open(opt, name, &db);
	assert(fake.ok());
}

int
dsm_db::put(string key, string value)
{
	assert(db);
	fake = db->Put(opt_w, key, value);
	return fake.ok();
}

int
dsm_db::get(string key, string *value)
{
	assert(db);
	fake = db->Get(opt_r, key, value);
	return fake.ok();
}

int
dsm_db::del(string key)
{
	assert(db);
	fake = db->Delete(opt_w, key);
	return fake.ok();
}

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
