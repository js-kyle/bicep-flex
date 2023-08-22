const { app } = require("@azure/functions");
const headers = { "content-type": "application/json" };

app.get("getOrder", {
  handler: async (request) => {
    try {
      const { connection } = require("../../lib/database");
      const order = await connection
        .model("Order")
        .findById(request.params.orderId);
      return { status: 200, body: order, headers };
    } catch (e) {
      return {
        status: 500,
        body: "Server error",
        headers,
      };
    }
  },
  route: "v1/order/{orderId}",
});

app.post("postOrder", {
  handler: async (request) => {
    try {
      const { connection } = require("../../lib/database");
      const body = await request.json();

      const order = await connection.model("Order").create({
        product: body.product,
        quantity: body.quantity,
      });

      return {
        status: 201,
        body: order,
        headers,
      };
    } catch (e) {
      return {
        status: 500,
        body: "Server error",
        headers,
      };
    }
  },
  route: "v1/order",
});
