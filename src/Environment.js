class Environment {
  _record;
  constructor(record = {}) {
    this._record = record;
  }

  isDefined(id) {
    return this._record.hasOwnProperty(id);
  }

  lookup(id) {
    if (!this.isDefined(id)) {
      throw new ReferenceError(`Variable ${id} is not defined`);
    }
    return this._record[id];
  }

  define(id, val) {
    this._record[id] = val;
    return val;
  }
}

module.exports = Environment;
