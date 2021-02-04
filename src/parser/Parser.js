class Passer {
  _input = "";

  parse(input) {
    this._input = input;
    return this.Program();
  }

  /**
   * Program
   *  : NumLit
   *  ;
   */
  Program() {
    return this.NumLit();
  }

  /**
   * NumLit
   *  : NUM
   *  ;
   */
  NumLit() {
    return {
      type: "NumLit",
      value: Number(this._input),
    };
  }
}

module.exports = Passer;
