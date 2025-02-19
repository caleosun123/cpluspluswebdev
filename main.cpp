#include <cpprest/http_listener.h>
#include <cpprest/json.h>

using namespace web;
using namespace web::http;
using namespace web::http::experimental::listener;

void handle_get(http_request request)
{
  ucout << "GET request recieved" << std::endl;
  json::value response_data;
  response_data[U("message")] = json::value::string(U("Hello, world!"));
  request.reply(status_codes::OK, response_data);
}

int main()
{
  uri_builder uri(U("http://localhost:8080"));
  auto addr = uri.to_uri().to_string();
  http_listener listener(addr);
  listener.support(methods::GET, handle_get);

  try
  {
    listener
      .open()
      .then([&listener]() { ucout << "Starting to listen on " << listener.uri().to_string() << std::endl })
      .wait();

    while (true);
  }
  catch (const std::exception &e)
  {
    std::wcout << e.what() << std::endl;
  }

  return 0;
}
