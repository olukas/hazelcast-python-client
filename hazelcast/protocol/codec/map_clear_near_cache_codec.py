from hazelcast.serialization.bits import *
from hazelcast.protocol.client_message import ClientMessage
from hazelcast.protocol.custom_codec import *
from hazelcast.util import ImmutableLazyDataList
from hazelcast.protocol.codec.map_message_type import *

REQUEST_TYPE = MAP_CLEARNEARCACHE
RESPONSE_TYPE = 100
RETRYABLE = False


def calculate_size(name, target):
    """ Calculates the request payload size"""
    data_size = 0
    data_size += calculate_size_str(name)
    data_size += calculate_size_address(target)
    return data_size


def encode_request(name, target):
    """ Encode request into client_message"""
    client_message = ClientMessage(payload_size=calculate_size(name, target))
    client_message.set_message_type(REQUEST_TYPE)
    client_message.set_retryable(RETRYABLE)
    client_message.append_str(name)
    AddressCodec.encode(client_message, target)
    client_message.update_frame_length()
    return client_message


# Empty decode_response(client_message), this message has no parameters to decode



