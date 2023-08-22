const { Schema, createConnection, model } = require("mongoose");

const connectionString = process.env.MONGODB_URI;

const connection = createConnection(connectionString, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  autoIndex: true,
  dbName: "bicepflex-mongo",
});

const OrderSchema = new Schema(
  {
    quantity: Number,
    product: String,
  },
  { collection: "orders", versionKey: false }
);

const Order = model("Order", OrderSchema);

connection.model("Order", OrderSchema);

module.exports = {
  connection,
  Order,
};
